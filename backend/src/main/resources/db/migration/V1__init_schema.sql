-- =============================================
-- Kulfi DB 초기 스키마
-- =============================================

-- ---------------------------------------------
-- members
-- ---------------------------------------------
CREATE TABLE members
(
    id         BIGINT       NOT NULL AUTO_INCREMENT,
    email      VARCHAR(100) NOT NULL,
    password   VARCHAR(255)          DEFAULT NULL COMMENT '소셜 로그인은 NULL',
    nickname   VARCHAR(50)  NOT NULL,
    role       ENUM ('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_members_email (email)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- ---------------------------------------------
-- boards
-- ---------------------------------------------
CREATE TABLE boards
(
    id         BIGINT        NOT NULL AUTO_INCREMENT,
    category   ENUM ('BOLLYWOOD', 'TOLLYWOOD') NOT NULL,
    title      VARCHAR(255)  NOT NULL,
    content    TEXT          NOT NULL,
    view_count INT           NOT NULL DEFAULT 0,
    member_id  BIGINT        NOT NULL,
    created_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_boards_member FOREIGN KEY (member_id) REFERENCES members (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- ---------------------------------------------
-- board_images
-- ---------------------------------------------
CREATE TABLE board_images
(
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    board_id    BIGINT       NOT NULL,
    file_name   VARCHAR(255) NOT NULL,
    upload_path VARCHAR(500) NOT NULL,
    uuid        VARCHAR(36)  NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_board_images_board FOREIGN KEY (board_id) REFERENCES boards (id) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- ---------------------------------------------
-- comments
-- ---------------------------------------------
CREATE TABLE comments
(
    id         BIGINT   NOT NULL AUTO_INCREMENT,
    board_id   BIGINT   NOT NULL,
    parent_id  BIGINT            DEFAULT NULL COMMENT '대댓글이면 부모 댓글 ID, 루트 댓글이면 NULL',
    content    TEXT     NOT NULL,
    member_id  BIGINT   NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_comments_board  FOREIGN KEY (board_id)  REFERENCES boards (id)   ON DELETE CASCADE,
    CONSTRAINT fk_comments_member FOREIGN KEY (member_id) REFERENCES members (id),
    CONSTRAINT fk_comments_parent FOREIGN KEY (parent_id) REFERENCES comments (id) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
