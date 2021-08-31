package com.nanhang.settings.web.controller;
import com.nanhang.exception.LoginException;
import com.nanhang.settings.domain.User;
import com.nanhang.settings.service.UserService;
import com.nanhang.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/settings/user")
public class UserContorller {
@Autowired
private UserService userService;
    public void setUserService(UserService userService) {
        this.userService = userService;
    }
    @RequestMapping(value = "/login.do",produces ="application/json")
  @ResponseBody
    /*@RequestBody注解用于读取http请求的内容(字符串)，
    通过springmvc提供的HttpMessageConverter接口将读到的内容转换为json、xml等格式的数据并绑定到controller方法的参数上。
   @ResponseBody该注解用于将Controller的方法返回的对象，
   通过HttpMessageConverter接口转换为指定格式的数据如：json,xml等，通过Response响应给客户端。
  由于json传递信息的方便性，用于传递json数据上的比较多。*/
   public Map<String,Object> userlogin(HttpServletRequest request, User user) throws LoginException{

        System.out.println("进入到用户登陆的控制器");
        System.out.println("进入到验证登录操作");
     //拿到jsp中的用户名和密码参数 以及改用户的ip地址
        //HttpServletRequest request作用
        // 调用getRemoteAddr得到浏览器的IP地址 以及把成功的账号添加到session域中

        String LoginAct = user.getLoginAct();
        String LoginPwd= user.getLoginPwd();
        System.out.println("sss"+LoginPwd);
        //将密码转为密文
        LoginPwd= MD5Util.getMD5(LoginPwd);
        //202cb962ac59075b964b07152d234b70
        //接受浏览器的IP地址
          String ip=request.getRemoteAddr();
        System.out.println(ip);
          Map<String,Object> map=new HashMap<>();
          //调用登入方法验证是否成功
        try{  user= userService.login(LoginAct,LoginPwd,ip);
         //如果成功
        map.put("success",true);
        map.put("user",user);
        //成功的账号添加到session域中
        System.out.println("asdsadas"+map+user);
        request.getSession().setAttribute("user",user);
        } catch (Exception e) {
            String msg=e.getMessage();
            map.put("msg",msg);
        }
        return map;

    }
    /*protected Map<String,Object> service(HttpServletRequest request,User user) throws LoginException {

        System.out.println("进入到用户登陆的控制器");

        System.out.println("进入到验证登录操作");
        String loginAct = user.getLoginAct();
        String loginPwd = user.getLoginPwd();
        // 将密码的明文形式转换为MD5的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        // 接收ip地址
        String ip = request.getRemoteAddr();
        System.out.println("----ip:" + ip);
        Map<String,Object> map = new HashMap<>();
        // 未来的业务层开发,统一使用代理类形态的接口对象
        user = us.login(loginAct, loginPwd, ip);

        map.put("success",true);
        request.getSession().setAttribute("user",user);
        return map;
    }

    @RequestMapping("/register.do")
    public void register() {
        System.out.println("进入到用户注册的控制器");
    }*/

}
