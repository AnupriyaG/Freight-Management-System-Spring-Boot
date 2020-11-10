/*
 * Copyright 2012-2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package edu.njit.fms;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Main Controller of the web application
 * @author Karthik Sankaran
 */
@Controller
public class WelcomeController {

	/**
	 * Home page
	 */
	@RequestMapping("/")
	public String welcome() {
		return "home";
	}

	/**
	 * Login page
	 */
	@RequestMapping("/auth")
	public String auth() {
		return "auth";
	}

	@RequestMapping("/session_refresh")
	@ResponseBody
	public String sessionRefresh() {
		return "REFRESH_OK";
	}

	/**
	 * This redirects all cals to the old admin page to the correct URL
	 * TODO: Remove this code (be carefull to remove all references to this URL)
	 */
	@RequestMapping(value = "/DisplayAdminMainPage",method = RequestMethod.GET)
	public String displayHomePage()
	{
		return "redirect:/";	
	}

	
}
