package com.zzrenfeng.base.service.impl;

import com.zzrenfeng.base.entity.BaseDomain;
import com.zzrenfeng.base.entity.Company;
import com.zzrenfeng.base.entity.Division;
import com.zzrenfeng.base.entity.Project;
import com.zzrenfeng.base.model.TreeModel;
import com.zzrenfeng.base.service.CompanyService;
import com.zzrenfeng.base.utils.Constants;
import com.zzrenfeng.base.utils.PageUtil;
import com.zzrenfeng.base.utils.StringUtil;
import com.zzrenfeng.base.utils.UUIDUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * topic 公司信息处理业务类
 * author zhoujincheng
 * create 2016/4/4 15:12
 */
@Transactional
@Service("companyService")
public class CompanyServiceImpl extends BaseServiceImpl<Company> implements CompanyService {

    private final Logger LOGGER = LoggerFactory.getLogger(CompanyServiceImpl.class);

    /**
     * Description: 获取所有的公司名称和ID
     * Name:getAllCoName
     * Author:zhoujincheng
     * Time:2016/4/26 10:19
     * param:[]
     * return:java.util.List<com.zzrenfeng.base.model.TreeModel>
     */
    @Override
    public List<TreeModel> getAllCoName() {
        List<Company> coList = companyMapper.findAll();
        return permToTree("0", coList);
    }


    //递归转化成菜单模型，支持无限级菜单
    private List<TreeModel> permToTree(String id, List<Company> list) {
        List<TreeModel> menuList = new ArrayList<>();
        list.stream().filter(co -> id.equals(co.getPrntId())).forEach(co -> {
            TreeModel menu = new TreeModel();
            menu.setState(Constants.TREE_STATUS_OPEN); //这里必须关闭节点，否则会出现无限节点
            menu.setId(co.getCoId());
            menu.setPid("0".equals(co.getPrntId()) ? "" : co.getPrntId());
            menu.setIconCls(co.getIconCls());
            menu.setText(co.getCoName());
            menu.setChildren(permToTree(co.getCoId(), list));
            menuList.add(menu);
        });
        return menuList;
    }


    @Override
    public List<Company> findComp(PageUtil pageUtil) {
        LOGGER.info("开始查找公司信息,分页显示");
        List<Company> compList = companyMapper.findAllByPage(pageUtil);
        return compList;
    }

    @Override
    public Long getCount(Map<String, Object> paramMap) {
        LOGGER.info("开始查找公司信息的总条数");
        return companyMapper.getCount(paramMap);
    }

    @Override
    public boolean delComp(String compId) {
        List<Division> divList = divisionMapper.findByCompId(compId);
        List<Company> coList = companyMapper.findByPid(compId);
        List<Project> pList = projectMapper.getPrjByCoId(compId);
        //如果公司下面有组织信息或子公司，则不能删除
        if (divList.size() > 0 && coList.size() > 0 && pList.size() > 0) {
            return false;
        } else {
            Company co = companyMapper.selectByPrimaryKey(compId);
            co.setStatus(Constants.PERSISTENCE_DELETE_STATUS);
            return companyMapper.updateByPrimaryKey(co) > 0;
        }
    }

    @Override
    public boolean persistenceComp(Company company) {

        String userId = Constants.getCurrendUser().getUserId();
        if (StringUtil.isEmpty(company.getCoId())) {
            BaseDomain.createLog(company, userId);
            company.setStatus(Constants.PERSISTENCE_STATUS);
            company.setCoId(UUIDUtils.getUUID());
            company.setState(Constants.TREE_STATUS_CLOSED);
            company.setIconCls(Constants.COMPANY_ICON);
            if (StringUtil.isEmpty(company.getPrntId())) {
                company.setPrntId("0");
            }
            companyMapper.insert(company);
        } else {
            BaseDomain.editLog(company, userId);
            companyMapper.updateByPrimaryKeySelective(company);
        }
        return true;
    }

    /**
     * Description: 查询某个公司下所有的公司信息，包含下属多级公司
     * Name:AllCoById
     * Author:zhoujincheng
     * Time:2016/4/28 11:10
     * param:[coId]
     * return:java.util.List<com.zzrenfeng.base.entity.Company>
     */
    @Override
    public List<Company> AllCoById(String coId) {
        List<Company> returnList = new ArrayList<>();

        returnList.add(companyMapper.selectByPrimaryKey(coId));
        List<Company> coList = new ArrayList<>();
        coList.add(companyMapper.selectByPrimaryKey(coId));
        returnList.addAll(findByPrntId(coId, coList).stream().collect(Collectors.toList()));

        return returnList;
    }

    //递归获取所有的子公司信息
    private List<Company> findByPrntId(String coId, List<Company> coList) {
        List<Company> allList = new ArrayList<>();
        for (Company company : coList) {
            List<Company> resultList = companyMapper.selectByPrntId(coId);
            if (resultList.size() > 0) {
                allList.addAll(resultList.stream().collect(Collectors.toList()));
                findByPrntId(company.getCoId(), resultList);
            }
        }
        return allList;
    }


    @Override
    public List<Company> findByPid(String pid) {
        List<Company> pList = StringUtil.isEmpty(pid) ?
                companyMapper.findByPid("0") : companyMapper.findByPid(pid);
        pList.stream().filter(Company -> StringUtil.isEmpty(pid)).forEach(Company -> Company.setPrntId("0"));
        return pList;
    }
}
