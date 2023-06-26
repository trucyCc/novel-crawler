package com.trucy.novel.auth.user.mapper.impl;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.trucy.novel.auth.user.mapper.NovelUserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.persistence.EntityManager;

@Slf4j
@Component
@AllArgsConstructor
public class NovelUserMapper {
    private NovelUserRepository novelUserRepository;
    private JPAQueryFactory jpaQueryFactory;


}
