/**
 * Title: PageUtil.java
 * Package com.zzrenfeng.base.utils
 * author  zhoujincheng
 * date 2015年9月14日 下午6:11:29
 * version V1.0
 * Copyright (c) 2015,zhoujincheng777@qq.com All Rights Reserved.
 */

package com.zzrenfeng.base.utils;

/**
 * ClassName: PageUtil
 * Description: 分页
 * author zhoujincheng
 * date 2015年9月14日 下午6:11:29
 */

public class PageUtil {

    /**
     * 分页查询开始记录位置.
     */
    private int begin;
    /**
     * 分页查看下结束位置.
     */
    private int end;
    /**
     * 每页显示记录数.默认10
     */
    private int length = Constants.DEFAULT_LENGTH;
    /**
     * 查询结果总记录数.
     */
    private int totalRecords;
    /**
     * 当前页码.
     */
    private int pageNo;
    /**
     * 总共页数.
     */
    private int pageCount;

    public PageUtil() {
    }

    /**
     * 构造函数.
     * <p>
     * param begin
     * param length
     */
    public PageUtil(int begin, int length) {
        this.begin = begin;
        this.length = length;
        this.end = this.begin + this.length;
        this.pageNo = (int) Math.floor((this.begin * 1.0d) / this.length) + 1;
    }

    /**
     * param begin
     * param length
     * param totalRecords
     */
    public PageUtil(int begin, int length, int totalRecords) {
        this(begin, length);
        this.totalRecords = totalRecords;
    }

    /**
     * 设置页数，自动计算数据范围.
     * <p>
     * param pageNo
     */
    public PageUtil(int pageNo) {
        this.pageNo = pageNo;
        pageNo = pageNo > 0 ? pageNo : 1;
        this.begin = this.length * (pageNo - 1);
        this.end = this.length * pageNo;
    }

    public int getBegin() {
        return begin;
    }

    public int getEnd() {
        return end;
    }


    public void setEnd(int end) {
        this.end = end;
    }

    public void setBegin(int begin) {
        this.begin = begin;
        if (this.length != 0) {
            this.pageNo = (int) Math.floor((this.begin * 1.0d) / this.length) + 1;
        }
    }

    public int getLength() {
        return length;
    }

    public void setLength(int length) {
        this.length = length;
        if (this.begin != 0) {
            this.pageNo = (int) Math.floor((this.begin * 1.0d) / this.length) + 1;
        }
    }

    public int getTotalRecords() {
        return totalRecords;
    }

    public void setTotalRecords(int totalRecords) {
        this.totalRecords = totalRecords;
        this.pageCount = (int) Math.floor((this.totalRecords * 1.0d) / this.length);
        if (this.totalRecords % this.length != 0) {
            this.pageCount++;
        }
    }

    public int getPageNo() {
        return pageNo;
    }

    public void setPageNo(int pageNo) {
        this.pageNo = pageNo;
        pageNo = pageNo > 0 ? pageNo : 1;
        this.begin = this.length * (pageNo - 1);
        this.end = this.length * pageNo;
    }

    public int getPageCount() {
        if (pageCount == 0) {
            return 1;
        }
        return pageCount;
    }

    public void setPageCount(int pageCount) {
        this.pageCount = pageCount;
    }


}
