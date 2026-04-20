-- =============================================
-- Kulfi DB 초기 스키마
-- =============================================

-- ---------------------------------------------
-- member
-- ---------------------------------------------
CREATE TABLE member
(
    id            BIGINT       NOT NULL AUTO_INCREMENT,
    email         VARCHAR(255) NOT NULL,
    password      VARCHAR(255)          DEFAULT NULL COMMENT '소셜 로그인은 NULL',
    nickname      VARCHAR(50)  NOT NULL,
    profile_image VARCHAR(500)          DEFAULT NULL COMMENT '프로필 이미지 경로',
    provider      ENUM ('LOCAL', 'GOOGLE', 'KAKAO', 'NAVER') NOT NULL DEFAULT 'LOCAL',
    provider_id   VARCHAR(255)          DEFAULT NULL COMMENT '소셜 로그인 식별자',
    role          ENUM ('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    last_login_at DATETIME              DEFAULT NULL COMMENT '마지막 로그인 일시',
    is_deleted    TINYINT(1)   NOT NULL DEFAULT 0,
    deleted_at    DATETIME              DEFAULT NULL,
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_member_email (email),
    UNIQUE KEY uq_member_nickname (nickname)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- ---------------------------------------------
-- board
-- ---------------------------------------------
CREATE TABLE board
(
    id         BIGINT       NOT NULL AUTO_INCREMENT,
    category   ENUM ('BOLLYWOOD', 'TOLLYWOOD') NOT NULL,
    title      VARCHAR(255) NOT NULL,
    content    TEXT         NOT NULL,
    view_count INT          NOT NULL DEFAULT 0,
    like_count INT          NOT NULL DEFAULT 0,
    member_id  BIGINT       NOT NULL,
    is_deleted TINYINT(1)   NOT NULL DEFAULT 0,
    deleted_at DATETIME              DEFAULT NULL,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_board_member FOREIGN KEY (member_id) REFERENCES member (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- ---------------------------------------------
-- board_image
-- ---------------------------------------------
CREATE TABLE board_image
(
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    board_id    BIGINT       NOT NULL,
    file_name   VARCHAR(255) NOT NULL,
    upload_path VARCHAR(500) NOT NULL,
    uuid        VARCHAR(36)  NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_board_image_board FOREIGN KEY (board_id) REFERENCES board (id) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- ---------------------------------------------
-- comment
-- ---------------------------------------------
CREATE TABLE comment
(
    id         BIGINT     NOT NULL AUTO_INCREMENT,
    board_id   BIGINT     NOT NULL,
    parent_id  BIGINT              DEFAULT NULL COMMENT '대댓글이면 부모 댓글 ID, 루트 댓글이면 NULL',
    content    TEXT       NOT NULL,
    member_id  BIGINT     NOT NULL,
    is_deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME            DEFAULT NULL,
    created_at DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_comment_board  FOREIGN KEY (board_id)  REFERENCES board (id)   ON DELETE CASCADE,
    CONSTRAINT fk_comment_member FOREIGN KEY (member_id) REFERENCES member (id),
    CONSTRAINT fk_comment_parent FOREIGN KEY (parent_id) REFERENCES comment (id) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- ---------------------------------------------
-- board_like
-- ---------------------------------------------
CREATE TABLE board_like
(
    id         BIGINT   NOT NULL AUTO_INCREMENT,
    board_id   BIGINT   NOT NULL,
    member_id  BIGINT   NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_board_like (board_id, member_id),
    CONSTRAINT fk_board_like_board  FOREIGN KEY (board_id)  REFERENCES board (id)  ON DELETE CASCADE,
    CONSTRAINT fk_board_like_member FOREIGN KEY (member_id) REFERENCES member (id) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
