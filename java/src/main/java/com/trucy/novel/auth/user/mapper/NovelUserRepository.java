package com.trucy.novel.auth.user.mapper;

import com.trucy.novel.auth.user.mapper.po.NovelUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface NovelUserRepository extends JpaRepository<NovelUser, Integer>, JpaSpecificationExecutor<NovelUser> {
}