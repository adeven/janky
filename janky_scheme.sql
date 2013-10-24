--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: branches; Type: TABLE; Schema: public; Owner: janky; Tablespace: 
--

CREATE TABLE branches (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    repository_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.branches OWNER TO janky;

--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: public; Owner: janky
--

CREATE SEQUENCE branches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branches_id_seq OWNER TO janky;

--
-- Name: branches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janky
--

ALTER SEQUENCE branches_id_seq OWNED BY branches.id;


--
-- Name: builds; Type: TABLE; Schema: public; Owner: janky; Tablespace: 
--

CREATE TABLE builds (
    id integer NOT NULL,
    green boolean DEFAULT false,
    url character varying(255),
    compare character varying(255) NOT NULL,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    commit_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    output text,
    room_id integer,
    "user" character varying(255),
    queued_at timestamp without time zone
);


ALTER TABLE public.builds OWNER TO janky;

--
-- Name: builds_id_seq; Type: SEQUENCE; Schema: public; Owner: janky
--

CREATE SEQUENCE builds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.builds_id_seq OWNER TO janky;

--
-- Name: builds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janky
--

ALTER SEQUENCE builds_id_seq OWNED BY builds.id;


--
-- Name: commits; Type: TABLE; Schema: public; Owner: janky; Tablespace: 
--

CREATE TABLE commits (
    id integer NOT NULL,
    sha1 character varying(255) NOT NULL,
    message text NOT NULL,
    author character varying(255) NOT NULL,
    committed_at timestamp without time zone,
    repository_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    url character varying(255) NOT NULL
);


ALTER TABLE public.commits OWNER TO janky;

--
-- Name: commits_id_seq; Type: SEQUENCE; Schema: public; Owner: janky
--

CREATE SEQUENCE commits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commits_id_seq OWNER TO janky;

--
-- Name: commits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janky
--

ALTER SEQUENCE commits_id_seq OWNED BY commits.id;


--
-- Name: repositories; Type: TABLE; Schema: public; Owner: janky; Tablespace: 
--

CREATE TABLE repositories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    uri character varying(255) NOT NULL,
    room_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    hook_url character varying(255),
    github_team_id integer
);


ALTER TABLE public.repositories OWNER TO janky;

--
-- Name: repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: janky
--

CREATE SEQUENCE repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.repositories_id_seq OWNER TO janky;

--
-- Name: repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janky
--

ALTER SEQUENCE repositories_id_seq OWNED BY repositories.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: janky; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO janky;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: janky
--

ALTER TABLE ONLY branches ALTER COLUMN id SET DEFAULT nextval('branches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: janky
--

ALTER TABLE ONLY builds ALTER COLUMN id SET DEFAULT nextval('builds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: janky
--

ALTER TABLE ONLY commits ALTER COLUMN id SET DEFAULT nextval('commits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: janky
--

ALTER TABLE ONLY repositories ALTER COLUMN id SET DEFAULT nextval('repositories_id_seq'::regclass);


--
-- Name: branches_pkey; Type: CONSTRAINT; Schema: public; Owner: janky; Tablespace: 
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);


--
-- Name: builds_pkey; Type: CONSTRAINT; Schema: public; Owner: janky; Tablespace: 
--

ALTER TABLE ONLY builds
    ADD CONSTRAINT builds_pkey PRIMARY KEY (id);


--
-- Name: commits_pkey; Type: CONSTRAINT; Schema: public; Owner: janky; Tablespace: 
--

ALTER TABLE ONLY commits
    ADD CONSTRAINT commits_pkey PRIMARY KEY (id);


--
-- Name: repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: janky; Tablespace: 
--

ALTER TABLE ONLY repositories
    ADD CONSTRAINT repositories_pkey PRIMARY KEY (id);


--
-- Name: index_branches_on_name_and_repository_id; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE UNIQUE INDEX index_branches_on_name_and_repository_id ON branches USING btree (name, repository_id);


--
-- Name: index_builds_on_branch_id; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE INDEX index_builds_on_branch_id ON builds USING btree (branch_id);


--
-- Name: index_builds_on_commit_id; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE INDEX index_builds_on_commit_id ON builds USING btree (commit_id);


--
-- Name: index_builds_on_completed_at; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE INDEX index_builds_on_completed_at ON builds USING btree (completed_at);


--
-- Name: index_builds_on_green; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE INDEX index_builds_on_green ON builds USING btree (green);


--
-- Name: index_builds_on_started_at; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE INDEX index_builds_on_started_at ON builds USING btree (started_at);


--
-- Name: index_builds_on_url; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE UNIQUE INDEX index_builds_on_url ON builds USING btree (url);


--
-- Name: index_commits_on_sha1_and_repository_id; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE UNIQUE INDEX index_commits_on_sha1_and_repository_id ON commits USING btree (sha1, repository_id);


--
-- Name: index_repositories_on_enabled; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE INDEX index_repositories_on_enabled ON repositories USING btree (enabled);


--
-- Name: index_repositories_on_name; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE UNIQUE INDEX index_repositories_on_name ON repositories USING btree (name);


--
-- Name: index_repositories_on_uri; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE INDEX index_repositories_on_uri ON repositories USING btree (uri);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: janky; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

