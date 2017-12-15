package com.cn.hnust.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cn.hnust.pojo.User;
import com.cn.hnust.service.IUserService;
import com.cn.hnust.unit.ValidateCode;

@Controller
@RequestMapping("/user")
public class UserController {
	@Resource
	private IUserService userService;
	@ResponseBody
	@RequestMapping(value="/login", method = RequestMethod.POST)
	public Object toIndex(HttpServletRequest request,@RequestBody Map<String, Object> map,String timestamp,String codes,String type){
		Map<String, Object> maps=new HashMap<String, Object>();
		maps.put("re", 1);
		HttpSession session = request.getSession();
		String code =session.getAttribute(timestamp)+"";
		if(!code.toUpperCase().equals(codes.toUpperCase())){
			maps.put("re", 0);
			maps.put("error", "5");
		}
		if(type.equals("1")){
			List<Map<String, Object>> list=userService.getUser(map);
			if(list.size()>0){
				maps.put("role", list.get(0).get("role"));
			}else{
				maps.put("re", 0);
				maps.put("error", "5");
			}
		}else{
			Map<String, Object> key=new 
					HashMap<String, Object>();
			key.put("user_name", map.get("user_name"));
			List<Map<String, Object>> list=userService.getUser(key);
			if(list.size()>0){
				maps.put("re", 0);
				maps.put("error", "5");
			}else{
				userService.insert(map);
			}
		}
		return maps; 
	}
	@RequestMapping(value="/validateCode") 
	public String validateCode(HttpServletRequest request,HttpServletResponse response,String timestamp) throws Exception{ 
	// ������Ӧ�����͸�ʽΪͼƬ��ʽ 
	response.setContentType("image/jpeg"); 
	//��ֹͼ�񻺴档 
	response.setHeader("Pragma", "no-cache"); 
	response.setHeader("Cache-Control", "no-cache"); 
	response.setDateHeader("Expires", 0); 

	HttpSession session = request.getSession(); 

	ValidateCode vCode = new ValidateCode(120,40,4,100); 
	session.setAttribute(timestamp, vCode.getCode()); 
	vCode.write(response.getOutputStream()); 
	return null; 
	}
	@ResponseBody
	@RequestMapping(value="/getUser", method = RequestMethod.POST)
	public Object getUser(@RequestBody Map<String, Object> map){
	List<Map<String, Object>> list=userService.getUser(map);
		return list; 
	}
	@ResponseBody
	@RequestMapping(value="/insert", method = RequestMethod.POST)
	public Object insert(@RequestBody Map<String, Object> map){
		Map<String, Object> maps=new HashMap<String, Object>();
	long list=userService.insert(map);
	maps.put("re", list);
		return maps; 
	}
	@ResponseBody
	@RequestMapping(value="/update", method = RequestMethod.POST)
	public Object update(@RequestBody Map<String, Object> map){
		Map<String, Object> maps=new HashMap<String, Object>();
		Map<String, Object> key=new 
				HashMap<String, Object>();
		key.put("user_name", map.get("user_name"));
		key.put("nid", map.get("id"));
		List<Map<String, Object>> lists=userService.getUser(key);
		if(lists.size()>0){
			maps.put("re", 0);
			maps.put("error", "5");
		}else{
			long list=userService.update(map);
			maps.put("re", list);
		}
			return maps; 
	}
	@ResponseBody
	@RequestMapping(value="/delete", method = RequestMethod.GET)
	public Object delete(Integer id){
		Map<String, Object> maps=new HashMap<String, Object>();
		long list=userService.delete(id);
		maps.put("re", list);
			return maps; 
	}
}
