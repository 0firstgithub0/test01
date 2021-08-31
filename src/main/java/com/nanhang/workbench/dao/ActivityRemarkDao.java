package com.nanhang.workbench.dao;



import com.nanhang.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    Integer getCountByAids(String[] ids);

    Integer deleteByAids(String[] ids);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    Integer deleteRemarkById(String id);

    int saveRemark(ActivityRemark ar);

    int updateRemark(ActivityRemark ar);

}
