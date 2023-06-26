package com.trucy.novel.auth.user.mapper;

import com.trucy.novel.auth.user.mapper.po.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRoleRepository extends JpaRepository<UserRole, Integer> {
}