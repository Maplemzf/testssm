package com.cn.hnust.dao;

import java.util.List;
import java.util.Map;

import com.cn.hnust.pojo.User;

public interface IUserDao {
    int deleteByPrimaryKey(Integer id);


    int insertSelective(Map<String, Object> map);


    int updateByPrimaryKeySelective(Map<String, Object> map );


	List<Map<String, Object>> selectByPrimaryKey(Map<String, Object> map);
}