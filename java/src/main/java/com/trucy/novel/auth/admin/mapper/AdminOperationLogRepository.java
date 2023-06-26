package com.trucy.novel.auth.admin.mapper;

import com.trucy.novel.auth.admin.mapper.po.AdminOperationLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminOperationLogRepository extends JpaRepository<AdminOperationLog, Integer> {
}