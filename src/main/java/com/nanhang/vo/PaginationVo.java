package com.nanhang.vo;

import java.util.List;
// PaginationVo<T>//使用泛型  是该类更有了扩展性 而不会因为某一个方法是类型写死
public class PaginationVo<T> {

    private int total;//需要查询返回的总条数
    private List<T> dataList;//市场活动信息表使用list封装

    @Override
    public String toString() {
        return "PaginationVo{" +
                "total=" + total +
                ", dataList=" + dataList +
                '}';
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
