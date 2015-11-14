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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: sort_array(anyarray); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sort_array(unsorted_array anyarray) RETURNS anyarray
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
        BEGIN
          RETURN (SELECT ARRAY_AGG(val) AS sorted_array
          FROM
          (SELECT
            UNNEST(string_to_array(lower(array_to_string(unsorted_array, ',')), ','))
            AS val ORDER BY val)
          AS sorted_vals);
        END;
      $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alerts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE alerts (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    email_address_id uuid NOT NULL,
    tags text[] DEFAULT '{}'::text[],
    last_sent_at timestamp without time zone,
    active boolean DEFAULT true NOT NULL,
    frequency character varying NOT NULL,
    search_query character varying
);


--
-- Name: alerts_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE alerts_jobs (
    alert_id uuid NOT NULL,
    job_id integer NOT NULL
);


--
-- Name: email_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE email_addresses (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    email character varying NOT NULL,
    validated_at timestamp without time zone,
    unsubscribed_at timestamp without time zone,
    validation_token text,
    login_token text
);


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobs (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    category_id integer,
    title character varying NOT NULL,
    posted_at timestamp without time zone,
    company character varying NOT NULL,
    location character varying NOT NULL,
    description text NOT NULL,
    company_url character varying,
    original_post_url character varying,
    source character varying,
    slug character varying,
    type character varying,
    sent_daily_alerts_at timestamp without time zone,
    sent_weekly_alerts_at timestamp without time zone,
    last_tweeted_at timestamp without time zone,
    tags text[] DEFAULT '{}'::text[],
    company_description text,
    how_to_apply text,
    user_id uuid,
    expires_at timestamp without time zone,
    status character varying
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobs_id_seq OWNED BY jobs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    email character varying NOT NULL,
    password_digest character varying NOT NULL,
    password_reset_token character varying,
    validation_token character varying,
    email_validated_at timestamp without time zone
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs ALTER COLUMN id SET DEFAULT nextval('jobs_id_seq'::regclass);


--
-- Name: alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: email_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY email_addresses
    ADD CONSTRAINT email_addresses_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_alerts_jobs_on_alert_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_alerts_jobs_on_alert_id ON alerts_jobs USING btree (alert_id);


--
-- Name: index_alerts_jobs_on_job_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_alerts_jobs_on_job_id ON alerts_jobs USING btree (job_id);


--
-- Name: index_alerts_on_email_address_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_alerts_on_email_address_id ON alerts USING btree (email_address_id);


--
-- Name: index_email_addresses_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_email_addresses_on_email ON email_addresses USING btree (email);


--
-- Name: index_email_addresses_on_unsubscribed_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_email_addresses_on_unsubscribed_at ON email_addresses USING btree (unsubscribed_at);


--
-- Name: index_email_addresses_on_validated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_email_addresses_on_validated_at ON email_addresses USING btree (validated_at);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_jobs_on_tags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_jobs_on_tags ON jobs USING btree (sort_array(tags));


--
-- Name: index_jobs_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_jobs_on_user_id ON jobs USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_1ec463f984; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY alerts_jobs
    ADD CONSTRAINT fk_rails_1ec463f984 FOREIGN KEY (job_id) REFERENCES jobs(id);


--
-- Name: fk_rails_236f10c72c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY alerts
    ADD CONSTRAINT fk_rails_236f10c72c FOREIGN KEY (email_address_id) REFERENCES email_addresses(id);


--
-- Name: fk_rails_c85ab29865; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY alerts_jobs
    ADD CONSTRAINT fk_rails_c85ab29865 FOREIGN KEY (alert_id) REFERENCES alerts(id);


--
-- Name: fk_rails_df6238c8a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_rails_df6238c8a6 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151006234240');

INSERT INTO schema_migrations (version) VALUES ('20151007213726');

INSERT INTO schema_migrations (version) VALUES ('20151007214637');

INSERT INTO schema_migrations (version) VALUES ('20151008000338');

INSERT INTO schema_migrations (version) VALUES ('20151008000339');

INSERT INTO schema_migrations (version) VALUES ('20151008000340');

INSERT INTO schema_migrations (version) VALUES ('20151008000341');

INSERT INTO schema_migrations (version) VALUES ('20151008000342');

INSERT INTO schema_migrations (version) VALUES ('20151010135711');

INSERT INTO schema_migrations (version) VALUES ('20151010143633');

INSERT INTO schema_migrations (version) VALUES ('20151010154618');

INSERT INTO schema_migrations (version) VALUES ('20151016004209');

INSERT INTO schema_migrations (version) VALUES ('20151016110402');

INSERT INTO schema_migrations (version) VALUES ('20151020195749');

INSERT INTO schema_migrations (version) VALUES ('20151022022231');

INSERT INTO schema_migrations (version) VALUES ('20151023122216');

INSERT INTO schema_migrations (version) VALUES ('20151023125824');

INSERT INTO schema_migrations (version) VALUES ('20151023213257');

INSERT INTO schema_migrations (version) VALUES ('20151024202708');

INSERT INTO schema_migrations (version) VALUES ('20151104215128');

INSERT INTO schema_migrations (version) VALUES ('20151105225052');

INSERT INTO schema_migrations (version) VALUES ('20151106222845');

INSERT INTO schema_migrations (version) VALUES ('20151108141959');

INSERT INTO schema_migrations (version) VALUES ('20151108222059');

INSERT INTO schema_migrations (version) VALUES ('20151108222409');

INSERT INTO schema_migrations (version) VALUES ('20151110220211');

INSERT INTO schema_migrations (version) VALUES ('20151111214936');

INSERT INTO schema_migrations (version) VALUES ('20151111220510');

INSERT INTO schema_migrations (version) VALUES ('20151112210536');

INSERT INTO schema_migrations (version) VALUES ('20151113225731');

