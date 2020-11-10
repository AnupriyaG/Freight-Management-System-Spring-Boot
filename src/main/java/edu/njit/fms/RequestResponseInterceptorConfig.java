package edu.njit.fms;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Component
public class RequestResponseInterceptorConfig extends WebMvcConfigurerAdapter {
   @Autowired
   RequestResponseInterceptor requestResponseInterceptor;

   @Override
   public void addInterceptors(InterceptorRegistry registry) {
      registry.addInterceptor(requestResponseInterceptor);
   }
}