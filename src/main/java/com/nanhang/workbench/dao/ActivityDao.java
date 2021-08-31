package com.nanhang.workbench.dao;



import com.nanhang.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int save(Activity activity);
    /*得到总条数*/
    Integer getTotalByCondition(Map<String, Object> map);
    //得到市场活动列表
    List<Activity> getActivityListByCondition(Map<String, Object> map);

    Integer delete(String[] ids);

    Activity getById(String id);

    int update(Activity a);

    Activity detail(String id);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String name);
}
