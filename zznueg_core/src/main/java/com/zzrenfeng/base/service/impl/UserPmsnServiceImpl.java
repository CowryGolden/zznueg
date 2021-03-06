package com.zzrenfeng.base.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.zzrenfeng.base.entity.BaseDomain;
import com.zzrenfeng.base.entity.UserPmsn;
import com.zzrenfeng.base.service.UserPmsnService;
import com.zzrenfeng.base.utils.Constants;
import com.zzrenfeng.base.utils.StringUtil;
import com.zzrenfeng.base.utils.UUIDUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Description:
 * author: zhoujincheng
 * date 2016/4/28 17:23
 */
@Transactional
@Service("userPmsnService")
public class UserPmsnServiceImpl extends BaseServiceImpl<UserPmsn> implements UserPmsnService {
    /**
     * 保存分配用户权限
     * param userId 用户id
     * param checkedIds 岗位ID集合
     * return
     */
    @Override
    public boolean saveUserPmsn(String userId, String checkedIds) {

        String currentUserId = Constants.getCurrendUser().getUserId();

        //盛放没有修改以前的对应记录，用于在修改后删除多余的记录
        Map<String, UserPmsn> map = new HashMap<>();

        //获取ID对应的所有权限
        List<UserPmsn> urList = userPmsnMapper.findAllByUserId(userId);
        //循环处理这些对应记录，逐一放入map中，然后设置该记录为过期，用于标记删除
        for (UserPmsn userPmsn : urList) {
            //对于该对应记录来说，互斥的ID当成key处理
            map.put(userPmsn.getPmsnId(), userPmsn);
            //设置所有记录过期
            updUserPmsn(currentUserId, userPmsn, Constants.PERSISTENCE_DELETE_STATUS);
        }

        //开始处理修改后提交的对应数据，checkedIds为权限集合
        if (null != checkedIds && !"".equals(checkedIds)) {
            String[] ids = checkedIds.split(",");
            for (String id : ids) {
                if (StringUtil.isEmpty(id)) {
                    continue;
                }
                //然后看这些权限ID是否在map中
                UserPmsn userPmsn = map.get(id);
                if (userPmsn != null) {
                    //如果在map中，说明在数据库中有记录，把状态改成正常
                    updUserPmsn(userId, userPmsn, Constants.PERSISTENCE_STATUS);
                } else {
                    //如果不在msp中，说明该对应记录在数据库中没有，要新增
                    userPmsn = new UserPmsn();
                    BaseDomain.createLog(userPmsn, userId);
                    userPmsn.setStatus(Constants.PERSISTENCE_STATUS);
                    //循环处理的ID
                    userPmsn.setPmsnId(id);
                    //传递过来的Id
                    userPmsn.setUserId(userId);
                    userPmsn.setUpmId(UUIDUtils.getUUID());
                    userPmsnMapper.insert(userPmsn);
                }
                //同时删除已经处理过的map值
                map.remove(id);
            }
        }
        //当所有值都处理完毕以后，剩下的map值就是：原来有对应关系，修改后没有对应关系，删除之
        for (Map.Entry<String, UserPmsn> entry : map.entrySet()) {
            userPmsnMapper.deleteByPrimaryKey(entry.getValue().getUpmId());
        }

        return true;
    }

    private void updUserPmsn(String userId, UserPmsn userPmsn, String status) {
        BaseDomain.editLog(userPmsn, userId);
        userPmsn.setStatus(status);
        userPmsnMapper.updateByPrimaryKeySelective(userPmsn);
    }

    /**
     * Description:  获取用户的所有直接权限映射信息
     * Name:findByUserId
     * Author:zhoujincheng
     * Time:2016/4/28 22:15
     * param:[userId]
     * return:java.util.List<com.zzrenfeng.base.entity.UserPmsn>
     */
    @Override
    public List<UserPmsn> findByUserId(String userId) {
        return userPmsnMapper.findAllByUserId(userId);
    }
}
