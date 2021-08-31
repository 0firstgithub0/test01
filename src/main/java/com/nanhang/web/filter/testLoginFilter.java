package com.nanhang.web.filter;


import com.nanhang.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class testLoginFilter implements Filter {


    @Override
    public void doFilter(ServletRequest res,
                         ServletResponse resp,
                         FilterChain chain) throws IOException, ServletException {

   //自定义拦截器过滤恶意请求
        //1得到请求对象和响应对象
        HttpServletRequest request= (HttpServletRequest) res;
        HttpServletResponse response= (HttpServletResponse) resp;
        request.getSession();
        String path=request.getServletPath();
      if("login.jsp".equals(path)||("settings/user/login.do").equals(path)){
        //排除登入界面和登入操作
        chain.doFilter(res,resp);
    }
    else {
        //判断会话作用域中时候有账号如果有则放行
       HttpSession session= request.getSession();
       //从session域中拿到user
         User user= (User)session.getAttribute("user");
        if(user!=null){
            chain.doFilter(res,resp);
        }
        else {
        //否则拦截请求重定向到登入界面 不使用请求转发的原因是该请求路径还是保留的原有请求路径并不会改变
          //需要下一个请求的绝对路径
          response.sendRedirect(request.getContentType()+"/login.jsp");
        }

    }
    }


}
