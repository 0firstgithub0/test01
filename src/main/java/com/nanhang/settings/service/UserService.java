package com.nanhang.settings.service;

import com.nanhang.exception.LoginException;
import com.nanhang.settings.domain.User;
import java.util.List;


public interface UserService {

    User login(String loginAct, String loginPwd, String ip) throws LoginException;
    List<User> getUserList();
}
