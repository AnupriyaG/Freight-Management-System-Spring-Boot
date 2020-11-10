package edu.njit.fms;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

/**
 * This class configures Springs session and security behaviour
 * @author Karthik Sankaran
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/auth", "/logout", "/assets/**", "/images/**", "/js/**", "/css/**", "/arcgis/**").permitAll()
                .anyRequest().authenticated()
                .and().sessionManagement().invalidSessionUrl("/auth?expired=1")
                .and()
            .formLogin()
                .loginPage("/auth")
                .permitAll()
                .and()
            .logout().logoutSuccessUrl("/auth").invalidateHttpSession(false)
                .permitAll().and().csrf().disable();
    }

    @Autowired
    DataSource dataSource;

    /**
     * Configures the Authentication mechanism
     * @param auth
     * @throws Exception
     */
    @Autowired
	public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .jdbcAuthentication()
            .dataSource(dataSource)
            .usersByUsernameQuery("select loginid, password, '1' as active from principle where loginid = ?")
            .authoritiesByUsernameQuery("SELECT loginid, value FROM profiletable where name='userGroup' and loginid=?");
		//auth.inMemoryAuthentication().withUser("Administrator").password("admin123").roles("USER");
	}
}