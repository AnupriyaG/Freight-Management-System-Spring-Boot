package edu.njit.fms;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Component
public class RequestResponseInterceptor implements HandlerInterceptor {
   @Override
   public boolean preHandle(
      HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        session.setMaxInactiveInterval(60*60);
      return true;
   }
   @Override
   public void postHandle(
      HttpServletRequest request, HttpServletResponse response, Object handler, 
      ModelAndView modelAndView) throws Exception {}
   
   @Override
   public void afterCompletion(HttpServletRequest request, HttpServletResponse response, 
      Object handler, Exception exception) throws Exception {}
}