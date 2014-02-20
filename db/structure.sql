--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    "time" character varying(255),
    venue character varying(255),
    description text,
    name character varying(255),
    host_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    date date
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    user_id integer,
    title character varying(255),
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: rsvps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rsvps (
    id integer NOT NULL,
    user_id integer,
    event_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rsvps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rsvps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rsvps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rsvps_id_seq OWNED BY rsvps.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: tools; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tools (
    id integer NOT NULL,
    name character varying(255),
    description text,
    checkedin boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer
);


--
-- Name: tools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tools_id_seq OWNED BY tools.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    phone character varying(255),
    admin boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    uid character varying(255),
    avatar_url character varying(255),
    token character varying(255),
    secret character varying(255),
    preferences boolean DEFAULT false
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rsvps ALTER COLUMN id SET DEFAULT nextval('rsvps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tools ALTER COLUMN id SET DEFAULT nextval('tools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: rsvps_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rsvps
    ADD CONSTRAINT rsvps_pkey PRIMARY KEY (id);


--
-- Name: tools_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140210185634');

INSERT INTO schema_migrations (version) VALUES ('20140210190848');

INSERT INTO schema_migrations (version) VALUES ('20140210191017');

INSERT INTO schema_migrations (version) VALUES ('20140210191304');

INSERT INTO schema_migrations (version) VALUES ('20140210220112');

INSERT INTO schema_migrations (version) VALUES ('20140210220506');

INSERT INTO schema_migrations (version) VALUES ('20140211193105');

INSERT INTO schema_migrations (version) VALUES ('20140211194319');

INSERT INTO schema_migrations (version) VALUES ('20140212232434');

INSERT INTO schema_migrations (version) VALUES ('20140213063256');

INSERT INTO schema_migrations (version) VALUES ('20140213065420');

INSERT INTO schema_migrations (version) VALUES ('20140213084836');

INSERT INTO schema_migrations (version) VALUES ('20140213091709');

INSERT INTO schema_migrations (version) VALUES ('20140219004145');

INSERT INTO schema_migrations (version) VALUES ('20140219004244');

INSERT INTO schema_migrations (version) VALUES ('20140220202409');

INSERT INTO schema_migrations (version) VALUES ('20140220225734');
