package edu.njit.fms.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import edu.njit.fms.db.entity.User;
import edu.njit.fms.db.repository.UserRepository;

@Controller
public class UsersListController {
	@Autowired
	UserRepository userRepository;

	@RequestMapping(value = "/users/list", method = RequestMethod.GET)
	public String display(Model model, HttpServletRequest request) {
		List<User> users = userRepository.listAllUsers();

		model.addAttribute("users", users);
		return "users/list";
	}

	@RequestMapping(value = "/users/view", method = RequestMethod.GET)
	public String displayuserdetails(@RequestParam("username") String username, Model model) {
		String selectedUserID = username;// authentication.getName();
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String currentUserGroup = ((GrantedAuthority) authentication.getAuthorities().toArray()[0]).getAuthority();
		String fullname = userRepository.getUserFullName(selectedUserID);
		String agency = userRepository.getUserAgencyAlias(selectedUserID);
		String email = userRepository.getUserEmail(selectedUserID);
		String group = userRepository.getUserGroup(selectedUserID);

		if (group.equals("telus_agency_admin_grp"))
			group = "Admin User";
		else if (group.equals("telus_user_grp"))
			group = "FMS User";

		else
			group = "Guest User";

		if (currentUserGroup.equals("telus_agency_admin_grp"))
			currentUserGroup = "Admin User";
		else if (currentUserGroup.equals("telus_user_grp"))
			currentUserGroup = "FMS User";

		else
			currentUserGroup = "Guest User";

		model.addAttribute("username", username);
		model.addAttribute("fullname", fullname);
		model.addAttribute("group", group);
		model.addAttribute("agency", agency);
		model.addAttribute("email", email);
		model.addAttribute("group_logged_in_user", currentUserGroup);
		model.addAttribute("Role", currentUserGroup);

		return "users/view";

	}

	@RequestMapping(value = "/users/modify", method = RequestMethod.GET)
	public String displaymodifyuser(@RequestParam("username") String loginID, Model model) {

		String fullname = userRepository.getUserFullName(loginID);
		String agency = userRepository.getUserAgencyAlias(loginID);
		String email = userRepository.getUserEmail(loginID);
		String group = userRepository.getUserGroup(loginID);
		String password = userRepository.getUserPassword(loginID);
		List<String> groupname = userRepository.getGroupList();

		if (group.equals("telus_guest_grp"))
			group = "Guest_User";
		else if (group.equals("telus_user_grp"))
			group = "FMS_User";
		else
			group = "Admin_User";

		//String Role = user.getGroupid();
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String currentUserGroup = ((GrantedAuthority) authentication.getAuthorities().toArray()[0]).getAuthority();
		
		model.addAttribute("Role", currentUserGroup);
		model.addAttribute("username", loginID);
		model.addAttribute("fullname", fullname);
		model.addAttribute("group", group);
		model.addAttribute("agency", agency);
		model.addAttribute("email", email);
		model.addAttribute("password", password);
		model.addAttribute("groupname", groupname);
		model.addAttribute("level", group);
		return "users/modify";

	}

	@RequestMapping(value = "/users/add", method = RequestMethod.GET)
	public String displayAddUser() {
		return "users/add";
	}

	@RequestMapping(value = "/users/AddUser", method = RequestMethod.POST)
	public String processAddUser(
		@RequestParam("userName") String userID, 
		@RequestParam("fullName") String fullName, 
		@RequestParam("password") String password, 
		@RequestParam("email") String email, 
		@RequestParam("level") String level, 
		Model model
	) {
		String group = "";
		if (level.equals("Guest_User"))
			group = "'telus_guest_grp'";
		else if (level.equals("FMS_User"))
			group = "'telus_user_grp'";
		else
			group = "'telus_agency_admin_grp'";

		int userCount = userRepository.validateUsername(userID);
		boolean userExists = false;

		if (userCount > 0)
			userExists = true;

		if (userExists == false) {
			// insert the user into the database
			userRepository.insertGroupMap(group, userID);
			userRepository.insertPrinciple(userID, fullName, password);
			userRepository.insertProfileTable1(userID, group);
			userRepository.insertProfileTable2(userID);
			userRepository.insertProfileTable3(userID, email);

			return "redirect:/users/list";
			// return display(request);
		} else {
			model.addAttribute("Error", "User already exists in the Database");
			return "users/add";
		}

	}

	@RequestMapping(value = "/users/DeleteUser", method = RequestMethod.GET)
	public String deleteuser(@RequestParam("username") String userID) {
		// delete the user into the database
		userRepository.deleteFromGroupMap(userID);
		userRepository.deleteFromPrinciple(userID);
		userRepository.deleteFromProfileTable(userID);

		return "redirect:/users/list";
	}

	@RequestMapping(value = "/users/delete", method = RequestMethod.GET)
	public String deleteuserconfirmation(
		@RequestParam("username") String loginID, 
		@RequestParam("fullname") String fullName, 
		Model model
		) {
		List<String> queryData = userRepository.selectForDeleteConfirm(loginID);

		String[] data = new String[5];
		data[0] = loginID;
		data[1] = fullName;
		int i = 2;
		for (String s : queryData) {
			data[i] = s;
			i++;
		}

		model.addAttribute("data", data);
		return "users/delete";

	}

	@RequestMapping(value = "/ModifyUser", method = RequestMethod.POST)
	public String modifyuser(
		@RequestParam("userName") String userID, 
		@RequestParam("fullName") String fullName, 
		@RequestParam("password") String password, 
		@RequestParam("email") String email, 
		@RequestParam("level") String level, 
		Model model
	) {
		String group = "";
		if (level.equals("Guest_User"))
			group = "'telus_guest_grp'";
		else if (level.equals("FMS_User"))
			group = "'telus_user_grp'";
		else
			group = "'telus_agency_admin_grp'";

		boolean userExists = false;
		int userCount = userRepository.validateUsername(userID);
		if (userCount > 0)
			userExists = true;

		if (userExists) {
			userRepository.deleteFromGroupMap(userID);
			userRepository.deleteFromPrinciple(userID);
			userRepository.deleteFromProfileTable(userID);
			userRepository.insertGroupMap(group, userID);
			userRepository.insertPrinciple(userID, fullName, password);
			userRepository.insertProfileTable1(userID, group);
			userRepository.insertProfileTable2(userID);
			userRepository.insertProfileTable3(userID, email);
			if (level.equals("Guest_User"))
				return "redirect:/users/view?username=" + userID;
			else if (level.equals("FMS_User"))
				return "redirect:/users/view?username=" + userID;
			else
				return "redirect:/users/list";
		} else {
			model.addAttribute("Error", "User already exists in the Database");
			return "user/modify";
		}
	}
}
