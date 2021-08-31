package com.nanhang.settings.service.impl;


import com.nanhang.exception.LoginException;
import com.nanhang.settings.dao.UserDao;
import com.nanhang.settings.domain.User;
import com.nanhang.settings.service.UserService;
import com.nanhang.utils.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;
    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }
    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        System.err.println("进入到验证登录操作111");

        Map<String,String> map = new HashMap<String,String>();
        //把参数中的账号和密码打包在map中
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        //调用登入方法确定用户
         User user=userDao.login(map);
         //如果user为空
        if(user==null){
            throw new LoginException("账号密码错误");
        }
        //如果账号已失效
        String ExpireTime=user.getExpireTime();
        String datetime= DateTimeUtil.getSysTime();
        if(ExpireTime.compareTo(datetime)<0){

            throw new LoginException("账号已失效");

        }
        //账号以上锁
        String lockstate=user.getLockState();
        if("0".equals(lockstate)){
            throw new LoginException("账号已锁定,请联系管理员");
        }
        //判断IP地址
        String allowIps = user.getAllowIps();
        if(!allowIps.contains(ip)){
            throw new LoginException("ip地址受限");
        }
        return user;
       /* Map<String,String> map = new HashMap<String,String>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userDao.login(map);
        if(user == null){
            throw new LoginException("账号密码错误");
        }
        // 如果程序能够成功执行到这里,说明账号密码是正确的
        // 需要继续向下验证其他3项信息
        // 验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        // compareTo()方法比较大小
        if(expireTime.compareTo(currentTime)<0){
            throw new LoginException("账号已失效");
        }
        // 判断锁定状态
        String lockState = user.getLockState();
        if("0".equals(lockState)){
            throw new LoginException("账号已锁定,请联系管理员");
        }
        // 判断ip地址
        String allowIps = user.getAllowIps();
        if(!allowIps.contains(ip)){
            throw new LoginException("ip地址受限");
        }
*/

    }

    @Override
    public List<User> getUserList() {
        List<User> list=userDao.getUserList();
        return list;
    }
}
