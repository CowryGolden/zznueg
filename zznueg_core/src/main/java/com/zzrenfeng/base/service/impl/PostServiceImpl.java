package com.zzrenfeng.base.service.impl;

import com.zzrenfeng.base.entity.*;
import com.zzrenfeng.base.model.TreeModel;
import com.zzrenfeng.base.service.PostService;
import com.zzrenfeng.base.utils.Constants;
import com.zzrenfeng.base.utils.StringUtil;
import com.zzrenfeng.base.utils.UUIDUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * Description:
 * author: zhoujincheng
 * date 2016/4/27 8:27
 */
@Transactional
@Service("postService")
public class PostServiceImpl extends BaseServiceImpl<Post> implements PostService {

    /**
     * Description: 根据部门ID查询该部门下所有的岗位信息
     * Name:finaPostByDiv
     * Author:zhoujincheng
     * Time:2016/4/27 8:36
     * param:[id]
     * return:java.util.List<com.zzrenfeng.base.entity.Post>
     */
    @Override
    public List<Post> finaPostByDiv(String id) {
        return postMapper.findPostByDiv(id);
    }

    /**
     * Description: 新增或修改岗位信息
     * Name:persistencePost
     * Author:zhoujincheng
     * Time:2016/4/27 9:17
     * param:[post]
     * return:java.lang.Boolean
     */
    @Override
    public Boolean persistencePost(Post post) {
        String userId = Constants.getCurrendUser().getUserId();
        if (StringUtil.isEmpty(post.getPostId())) {
            BaseDomain.createLog(post, userId);
            post.setStatus(Constants.PERSISTENCE_STATUS);
            post.setPostId(UUIDUtils.getUUID());
            postMapper.insert(post);
        } else {
            BaseDomain.editLog(post, userId);
            postMapper.updateByPrimaryKeySelective(post);
        }
        return true;
    }

    /**
     * Description: 获取所有可添加岗位的公司和部门
     * Name:getCoDivList
     * Author:zhoujincheng
     * Time:2016/4/27 10:02
     * param:[]
     * return:java.util.List<com.zzrenfeng.base.model.TreeModel>
     */
    @Override
    public List<TreeModel> getCoDivList() {
        //获取所有的公司信息，并用treeModel格式化
        List<Company> coList = companyMapper.findAll();
        List<TreeModel> coTrees = coToTree("0", coList);
        childToTree(coTrees);
        return coTrees;
    }

    //添加部门数据到公司树模型下
    private void childToTree(List<TreeModel> list) {
        for (TreeModel treeModel : list) {
            List<TreeModel> coChild = treeModel.getChildren();
            if (coChild.size() == 0) {
                //获取每个节点的id，即公司id
                String coId = treeModel.getId();
                //获取该公司下属的所有部门
                List<Division> divList = divisionMapper.findByCompId(coId);
                //把部门加入公司节点内
                addDivToCo(divList, coChild);
            } else {
                List<TreeModel> childList = treeModel.getChildren();
                //内层循环，添加节点
                childToTree(childList);
                //获取每个节点的id，即公司id
                String coId = treeModel.getId();
                //获取该公司下属的所有部门
                List<Division> divList = divisionMapper.findByCompId(coId);
                //把部门加入公司节点内
                addDivToCo(divList, childList);
            }
        }
    }

    //把部门加入公司节点内
    private void addDivToCo(List<Division> list, List<TreeModel> childList) {
        for (Division div : list) {
            TreeModel tm = new TreeModel();
            tm.setId(div.getDivId());
            tm.setIconCls(div.getIconCls());
            tm.setPid("DIV");
            tm.setText(div.getDivName());
            tm.setState(Constants.TREE_STATUS_OPEN);
            childList.add(tm);
        }
    }


    //公司递归转化成Tree模型，支持无限级节点
    private List<TreeModel> coToTree(String id, List<Company> list) {
        List<TreeModel> menuList = new ArrayList<>();
        list.stream().filter(co -> id.equals(co.getPrntId())).forEach(co -> {
            TreeModel menu = new TreeModel();
            menu.setState(Constants.TREE_STATUS_OPEN); //这里必须关闭节点，否则会出现无限节点
            menu.setId(co.getCoId());
            menu.setPid("0".equals(co.getPrntId()) ? "" : co.getPrntId());
            menu.setIconCls(co.getIconCls());
            menu.setText(co.getCoName());
            menu.setChildren(coToTree(co.getCoId(), list));
            menuList.add(menu);
        });
        return menuList;
    }

    @Override
    public boolean delPostById(String postId) {
        //先检查岗位下是否有用户，判断能否删除岗位
        List<UserPost> upList = userPostMapper.findByPostId(postId);
        if (upList.size() > 0) {
            return false;
        } else {
            //没有用户的岗位可以删除，首先删除岗位角色的对应关系，然后删除岗位
            List<PostRole> prList = postRoleMapper.findAllByPostId(postId);
            for (PostRole postRole : prList) {
                postRoleMapper.deleteByPrimaryKey(postRole.getPrId());
            }
            Post post = postMapper.selectByPrimaryKey(postId);
            post.setStatus(Constants.PERSISTENCE_DELETE_STATUS);
            return postMapper.updateByPrimaryKey(post) > 0;
        }
    }
}
