/* Table Creation -------------------------------------------------------------------------------- */

CREATE TABLE adventure (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  text varchar(2000) DEFAULT NULL,
  UNIQUE KEY idx_adventure_id (id) COMMENT primary key
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;



CREATE TABLE cache (
  id int(11) NOT NULL AUTO_INCREMENT,
  cache_grp_id int(11) NOT NULL,
  name varchar(100) NOT NULL,
  text varchar(2000) DEFAULT NULL,
  street varchar(100) DEFAULT NULL,
  gps_lat decimal(10,7) NOT NULL,
  gps_long decimal(10,7) NOT NULL,
  target_img_file mediumblob,
  target_img_file_name varchar(50) DEFAULT NULL,
  target_img_name varchar(50) DEFAULT NULL,
  target_img_file_type varchar(10) DEFAULT NULL,
  target_width float DEFAULT NULL,
  UNIQUE KEY idx_location_id (id),
  KEY fk_cache_cache_grp_id (cache_grp_id),
  CONSTRAINT fk_cache_cache_grp_id FOREIGN KEY (cache_grp_id) REFERENCES cache_group (id)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=latin1;


CREATE TABLE cache_group (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  city_id int(11) NOT NULL,
  target_img_dat_file_name varchar(30) DEFAULT NULL,
  target_img_dat_file mediumblob,
  target_img_xml_file_name varchar(30) DEFAULT NULL,
  target_img_xml_file blob,
  text varchar(2000) DEFAULT NULL,
  UNIQUE KEY idx_cache_group_id (id) COMMENT 'primary key',
  KEY fk_cache_group_city_id (city_id),
  CONSTRAINT fk_cache_group_city_id FOREIGN KEY (city_id) REFERENCES city (id)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;


CREATE TABLE city (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  country varchar(100) DEFAULT NULL,
  zip varchar(10) DEFAULT NULL,
  UNIQUE KEY idx_city_id (id) COMMENT 'primary key'
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;


CREATE TABLE city_adventure (
  city_id int(11) NOT NULL,
  adventure_id int(11) NOT NULL,
  KEY fk_city_adventure_adventure_id (adventure_id),
  KEY fk_city_adventure_city_id (city_id),
  CONSTRAINT fk_city_adventure_adventure_id FOREIGN KEY (adventure_id) REFERENCES adventure (id),
  CONSTRAINT fk_city_adventure_city_id FOREIGN KEY (city_id) REFERENCES city (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE object3D (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  text varchar(2000) DEFAULT NULL,
  mtl_file mediumblob,
  obj_file mediumblob,
  obj_file_name varchar(30) DEFAULT NULL,
  mtl_file_name varchar(30) DEFAULT NULL,
  image mediumblob,
  obj_scale_factor double DEFAULT NULL,
  UNIQUE KEY idx_object3D_id (id) COMMENT 'primary key'
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;


CREATE TABLE riddle (
  id int(11) NOT NULL AUTO_INCREMENT,
  challenge_text varchar(100) NOT NULL,
  response_text varchar(100) NOT NULL,
  hint_text varchar(200) DEFAULT NULL,
  UNIQUE KEY idx_riddle_id (id) COMMENT 'primary key'
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;


CREATE TABLE scene (
  id int(11) NOT NULL AUTO_INCREMENT,
  story_id int(11) NOT NULL,
  seq_nr int(11) NOT NULL,
  name varchar(100) NOT NULL,
  text varchar(2000) DEFAULT NULL,
  riddle_id int(11) DEFAULT NULL,
  object3D_id int(11) DEFAULT NULL,
  UNIQUE KEY idx_scene_id (id) COMMENT 'primary key',
  KEY fk_scene_story_id (story_id),
  KEY fk_scene_riddle_id (riddle_id),
  KEY fk_scene_object3D_id (object3D_id),
  CONSTRAINT fk_scene_object3D_id FOREIGN KEY (object3D_id) REFERENCES object3D (id),
  CONSTRAINT fk_scene_riddle_id FOREIGN KEY (riddle_id) REFERENCES riddle (id),
  CONSTRAINT fk_scene_story_id FOREIGN KEY (story_id) REFERENCES story (id)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;


CREATE TABLE scene_cache (
  scene_id int(11) NOT NULL,
  cache_id int(11) NOT NULL,
  KEY fk_scene_cache_cache_id (cache_id),
  KEY fk_scene_cache_scene_id (scene_id),
  CONSTRAINT fk_scene_cache_cache_id FOREIGN KEY (cache_id) REFERENCES cache (id),
  CONSTRAINT fk_scene_cache_scene_id FOREIGN KEY (scene_id) REFERENCES scene (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE story (
  id int(11) NOT NULL AUTO_INCREMENT,
  adventure_id int(11) NOT NULL,
  seq_nr int(11) NOT NULL,
  name varchar(100) NOT NULL,
  text varchar(2000) DEFAULT NULL,
  UNIQUE KEY idx_story_id (id) COMMENT 'primary key',
  KEY fk_story_adventure_id (adventure_id),
  CONSTRAINT fk_story_adventure_id FOREIGN KEY (adventure_id) REFERENCES adventure (id)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;


CREATE TABLE texture (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  object3D_id int(11) DEFAULT NULL,
  image_type varchar(10) DEFAULT NULL,
  image mediumblob,
  PRIMARY KEY (id),
  KEY fk_texture_object3D_id (object3D_id),
  CONSTRAINT fk_texture_object3D_id FOREIGN KEY (object3D_id) REFERENCES object3D (id)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=latin1;


/* View Creation ------------------------------------------------------------------------------ */

CREATE VIEW v_adventure_cache AS
SELECT adv.id AS adv_id,
       adv.name AS adv_name,
       adv.text AS adv_text,
       sto.id AS sto_id,
       sto.seq_nr AS sto_seq_nr,
       sto.name AS sto_name,
       sto.text AS sto_text,
       sce.id AS sce_id,
       sce.seq_nr AS sce_seq_nr,
       sce.name AS sce_name,
       sce.text AS sce_text,
       rid.id AS rid_id,
       rid.challenge_text AS rid_challenge,
       rid.response_text AS rid_response,
       rid.hint_text AS rid_hint,
       cag.id AS cag_id,
       cag.name AS cag_name,
       cag.text AS cag_text,
       cah.id AS cah_id,
       cah.name AS cah_name,
       cah.text AS cah_text,
       cah.street AS cah_street,
       cah.gps_lat AS cah_gps_lat,
       cah.gps_long AS cah_gps_long,
       cah.target_img_name AS cah_target_img_name,
       cah.target_width AS cah_target_width,
       obj.id AS obj_id,
       obj.name AS obj_name,
       obj.text AS obj_text
FROM (((((((adventure adv
            JOIN story sto)
           JOIN scene sce)
          JOIN scene_cache sca)
         JOIN cache_group cag)
        JOIN riddle rid)
       JOIN cache cah)
      JOIN object3d obj)
WHERE ((adv.id = sto.adventure_id)
       AND (sto.id = sce.story_id)
       AND (sce.id = sca.scene_id)
       AND (rid.id = sce.riddle_id)
       AND (cag.id = cah.cache_grp_id)
       AND (cah.id = sca.cache_id)
       AND (obj.id = sce.object3d_id))
ORDER BY cag.id,
         adv.id,
         sto.seq_nr,
         sce.seq_nr;


CREATE VIEW v_adventure_scene AS
SELECT adv.id AS adv_id,
       adv.name AS adv_name,
       adv.text AS adv_text,
       sto.id AS sto_id,
       sto.seq_nr AS sto_seq_nr,
       sto.name AS sto_name,
       sto.text AS sto_text,
       sce.id AS sce_id,
       sce.seq_nr AS sce_seq_nr,
       sce.name AS sce_name,
       sce.text AS sce_text,
       rid.id AS rid_id,
       rid.challenge_text AS rid_challenge,
       rid.response_text AS rid_response,
       rid.hint_text AS rid_hint,
       obj.id AS obj_id,
       obj.name AS obj_name,
       obj.text AS obj_text,
       obj.obj_file_name AS obj_file_name
FROM (adventure adv
      LEFT JOIN (story sto
                 LEFT JOIN ((scene sce
                             LEFT JOIN riddle rid on((rid.id = sce.riddle_id)))
                             LEFT JOIN object3d obj on((obj.id = sce.object3d_id))) on((sto.id = sce.story_id))) on((adv.id = sto.adventure_id)))
ORDER BY adv.id,
         sto.id,
         sto.seq_nr,
         sce.seq_nr;


CREATE VIEW v_city_cache AS
SELECT city.id AS city_id,
       city.name AS city_name,
       city.zip AS city_zip,
       city.country AS city_country,
       cgrp.id AS cgrp_id,
       cgrp.name AS cgrp_name,
       cgrp.text AS cgrp_text,
       cgrp.target_img_dat_file_name AS target_img_dat_file_name,
       cgrp.target_img_xml_file_name AS target_img_xml_file_name,
       cache.id AS cache_id,
       cache.name AS cache_name,
       cache.target_img_name AS target_img_name,
       cache.target_width AS target_width,
       cache.text AS cache_text,
       cache.street AS street,
       cache.gps_lat AS gps_lat,
       cache.gps_long AS gps_long,
       cache.target_img_name AS target_img_file_name
FROM (city
      LEFT JOIN (cache_group cgrp
                 LEFT JOIN cache on((cgrp.id = cache.cache_grp_id))) on((city.id = cgrp.city_id)))
ORDER BY city.name,
         cgrp.name,
         cache.name;


CREATE VIEW v_object3d AS
SELECT obj.id AS obj_id,
       obj.name AS obj_name,
       obj.text AS obj_text,
       obj.obj_file_name AS obj_obj_file_name,
       obj.mtl_file_name AS obj_mtl_file_name,
       obj.obj_scale_factor AS obj_scale_factor,
       tex.id AS tex_id,
       tex.name AS tex_name,
       tex.image_type AS tex_type
FROM (object3d obj
      LEFT JOIN texture tex on((obj.id = tex.object3d_id)));

