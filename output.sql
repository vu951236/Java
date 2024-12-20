--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: donhang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donhang (
    id integer NOT NULL,
    id_user integer NOT NULL,
    sanpham character varying(255) NOT NULL,
    soluong integer NOT NULL,
    thoigian timestamp without time zone NOT NULL,
    price double precision,
    trangthai character varying(255) DEFAULT 'Ch╞░a xß╗¡ l├¡'::character varying
);


ALTER TABLE public.donhang OWNER TO postgres;

--
-- Name: donhang_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donhang_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donhang_id_seq OWNER TO postgres;

--
-- Name: donhang_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donhang_id_seq OWNED BY public.donhang.id;


--
-- Name: hocacanhan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hocacanhan (
    id integer NOT NULL,
    user_id integer NOT NULL,
    ho_name character varying(100) NOT NULL,
    ho_length integer NOT NULL,
    ho_width integer NOT NULL,
    ho_height integer NOT NULL,
    fish_count integer NOT NULL,
    plant_count integer,
    ho_image character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.hocacanhan OWNER TO postgres;

--
-- Name: hocacanhan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hocacanhan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hocacanhan_id_seq OWNER TO postgres;

--
-- Name: hocacanhan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hocacanhan_id_seq OWNED BY public.hocacanhan.id;


--
-- Name: idadmin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idadmin (
    id character varying(255) NOT NULL,
    expiration_time timestamp without time zone NOT NULL
);


ALTER TABLE public.idadmin OWNER TO postgres;

--
-- Name: productsca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productsca (
    id integer NOT NULL,
    name text NOT NULL,
    ghichu text,
    image_path character varying(255),
    hansudung date,
    soluong integer,
    price double precision
);


ALTER TABLE public.productsca OWNER TO postgres;

--
-- Name: productsca_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productsca_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productsca_id_seq OWNER TO postgres;

--
-- Name: productsca_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productsca_id_seq OWNED BY public.productsca.id;


--
-- Name: productsnuoc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productsnuoc (
    id integer NOT NULL,
    name text NOT NULL,
    ghichu text,
    image_path character varying(255),
    hansudung date,
    soluong integer,
    price double precision
);


ALTER TABLE public.productsnuoc OWNER TO postgres;

--
-- Name: productsnuoc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productsnuoc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productsnuoc_id_seq OWNER TO postgres;

--
-- Name: productsnuoc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productsnuoc_id_seq OWNED BY public.productsnuoc.id;


--
-- Name: thongtinca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thongtinca (
    id integer NOT NULL,
    name character varying(255),
    ghichu text,
    image_path1 character varying(255),
    image_path2 character varying(255),
    image_path3 character varying(255),
    image_path4 character varying(255),
    khainiem text,
    dacdiem text,
    dinhduong text,
    phanloai text,
    phanbiet text
);


ALTER TABLE public.thongtinca OWNER TO postgres;

--
-- Name: thongtinca_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.thongtinca_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.thongtinca_id_seq OWNER TO postgres;

--
-- Name: thongtinca_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.thongtinca_id_seq OWNED BY public.thongtinca.id;


--
-- Name: thongtinho; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thongtinho (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    mota text NOT NULL,
    ghichu text NOT NULL,
    loai character varying(50),
    kichthuoc character varying(50),
    nhungcayphu character varying(255),
    loaicaphuhop character varying(255),
    image_path1 character varying(255),
    image_path2 character varying(255),
    image_path3 character varying(255),
    image_path4 character varying(255)
);


ALTER TABLE public.thongtinho OWNER TO postgres;

--
-- Name: thongtinho_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.thongtinho_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.thongtinho_id_seq OWNER TO postgres;

--
-- Name: thongtinho_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.thongtinho_id_seq OWNED BY public.thongtinho.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    fullname character varying(100) NOT NULL,
    address character varying(255),
    isadmin boolean DEFAULT false,
    avatar character varying(255),
    banned_until timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: donhang id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donhang ALTER COLUMN id SET DEFAULT nextval('public.donhang_id_seq'::regclass);


--
-- Name: hocacanhan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hocacanhan ALTER COLUMN id SET DEFAULT nextval('public.hocacanhan_id_seq'::regclass);


--
-- Name: productsca id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productsca ALTER COLUMN id SET DEFAULT nextval('public.productsca_id_seq'::regclass);


--
-- Name: productsnuoc id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productsnuoc ALTER COLUMN id SET DEFAULT nextval('public.productsnuoc_id_seq'::regclass);


--
-- Name: thongtinca id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thongtinca ALTER COLUMN id SET DEFAULT nextval('public.thongtinca_id_seq'::regclass);


--
-- Name: thongtinho id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thongtinho ALTER COLUMN id SET DEFAULT nextval('public.thongtinho_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: donhang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donhang (id, id_user, sanpham, soluong, thoigian, price, trangthai) FROM stdin;
1	1	EM-CAKOI	2	2024-10-17 15:55:49.485	280000	Ch╞░a xß╗¡ l├¡
2	1	EMZEO	2	2024-10-17 17:58:21.239	70000	Ch╞░a xß╗¡ l├¡
3	1	EMZEO	1	2024-10-17 18:01:36.137	35000	Ch╞░a xß╗¡ l├¡
4	2	EMZEO	2	2024-10-17 23:50:03.884	70000	─É├ú ho├án th├ánh
\.


--
-- Data for Name: hocacanhan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hocacanhan (id, user_id, ho_name, ho_length, ho_width, ho_height, fish_count, plant_count, ho_image, created_at) FROM stdin;
3	3	Hß╗ô c├í Koi ngo├ái trß╗¥i 	200	100	50	20	10	images/thiet-ke-ho-ca-koi-greenmore15.png	2024-10-07 10:31:48.176684
2	2	Hß╗ô c├í Koi ngo├ái trß╗¥i 	200	100	50	20	10	images/thiet-ke-ho-ca-koi-greenmore15.png	2024-10-07 10:35:00.152132
1	1	Hß╗ô c├í Koi ngo├ái trß╗¥i 	200	100	80	20	10	images/thiet-ke-ho-ca-koi-greenmore15.png	2024-10-11 18:33:35.046464
\.


--
-- Data for Name: idadmin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.idadmin (id, expiration_time) FROM stdin;
\.


--
-- Data for Name: productsca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productsca (id, name, ghichu, image_path, hansudung, soluong, price) FROM stdin;
1	EM-CAKOI	L├ám trong sß║ích nguß╗ôn n╞░ß╗¢c. Chß║╖n tß║úo lam. Khß╗¡ m├╣i h├┤i, kh├¡ ─æß╗Öc.	tinhchattoi.jpeg	2025-12-31	6	140000
2	Corion Pro	- Gi├║p c├ón bß║▒ng d╞░ß╗íng chß║Ñt cho t├┤m, c├í ph├ít triß╗ân ß╗òn ─æß╗ïnh.\r\n- T─âng tr╞░ß╗ƒng nhanh, d├ái ─æ├▓n, tr├ính hiß╗çn t╞░ß╗úng c├▓i cß╗ìt, ph├ón ─æ├án.\r\n- Body c├ón ─æß╗æi, l├¬n m├áu sß║»c tß╗▒ nhi├¬n v├á ─æß║¡m n├⌐t.	corion-pro.webp	2025-10-15	10	580000
3	Promotor L	T─âng c╞░ß╗¥ng dinh d╞░ß╗íng gi├║p t├┤m khoß║╗ mß║ính, chß║»c thß╗ït, t─âng trß╗ìng nhanh.\r\nT├┤m c├│ sß╗⌐c ─æß╗ü kh├íng cao, vß╗Å lß╗Öt nhiß╗üu, giß║úm stress, luß╗Öc l├¬n m├áu ─æß╗Å.\r\nPh├▓ng & trß╗ï bß╗çnh mß╗üm vß╗Å kinh ni├¬n.	promoto-l.webp	2025-10-15	10	350000
4	Roxacin	Thuß╗æc ph├▓ng ngß╗½a v├á ─æiß╗üu trß╗ï bß╗çnh nß║Ñm mang, thß╗æi mang tr├¬n c├í Koi	tickamit-roxacin.webp	2025-06-04	10	2000000
5	Calinil 100ml 	Diß╗çt k├╜ sinh tr├╣ng kh├┤ng x╞░╞íng sß╗æng bao gß╗ôm ng├ánh giun dß║╣t - s├ín, ─æ╞ín chß╗º (16-18 m├│c), song chß╗º (s├ín l├í gan lß╗¢n, nhß╗Å...), s├ín d├óy (ph├ón ─æß╗æt, kh├┤ng ph├ón mß╗Öt phß║ºn ng├ánh ─æa b├áo & nß╗Öi k├╜ sinh (giun tr├▓n, giun ─æß║ºu gai, giun ─æß╗æt, Gregarine, tr├╣ng b├áo tß╗¡ )ΓÇª	calinil-100ml-w.webp	2025-10-15	20	620000
6	Tickamit 12.5	─Éß║╖c trß╗ï c├íc loß║íi nß║Ñm tr├¬n c├í, t├┤m: nß║Ñm mang, nß║Ñm thuß╗╖ mi, nß║Ñm g├óy lß╗ƒ lo├⌐t, nß║Ñm trß║»ng, nß║Ñm ─æen, nß║Ñm r├óu, nß║Ñm ch├ón ch├│-─æß╗ông tiß╗ün, nß║Ñm Pythium isnidiosum g├óy ─æß╗æm ─æen tr├¬n t├┤m, nß║Ñm Lagenidium, Siropodium, Haliphthoros v├á Fusarium. Lagenidium, Siropodium, Haliphthoros v├á Fusarium ...	5f287a09-6ddb-4f37-8965-17b899592847-jpeg.webp	2025-06-11	10	380000
7	Ceftiomax	Ceftiomax ─æ╞░ß╗úc chß╗ë ─æß╗ïnh ─æiß╗üu trß╗ï vi├¬m nhiß╗àm khuß║⌐n cho nhß╗»ng tr╞░ß╗¥ng hß╗úp m├á ─æ├ú ─æiß╗üu trß╗ï vß╗¢i tß║Ñt cß║ú c├íc loß║íi kh├íng sinh kh├íc bß╗ï thß║Ñt bß║íi.	ceftiomax-100ml-w.webp	2025-06-05	10	620000
8	KS KOI	─Éiß╗üu trß╗ï hß║ºu hß║┐t c├íc bß╗çnh nhiß╗àm tr├╣ng nh╞░: lß╗ƒ lo├⌐t, xuß║Ñt huyß║┐t, nß║Ñm mangΓÇª tr├¬n c├í Koi do c├íc vi khuß║⌐n	ks-koi.webp	2025-06-04	10	230000
9	Brontox	Thuß╗æc nß║Ñm Bron Tox l├á chß║Ñt ─æß║╖c trß╗ï vi nß║Ñm cho c├í, ─æ╞░ß╗úc sß╗¡ dß╗Ñng rß╗Öng r├úi tr├¬n to├án thß║┐ giß╗¢i, ─æß║╖c biß╗çt ß╗ƒ Nhß║¡t Bß║ún ─æ╞░ß╗úc d├╣ng phß╗ò biß║┐n trong sß║ún xuß║Ñt c├í ...	bron-tox-trß╗ï-nß║Ñm-300x400.jpg	2025-06-04	10	120000
10	Cmin Plus	Cung cß║Ñp vitamin va kho├íng chß║Ñt gi├║p c├í khß╗Åe. ─én hß║▒ng ng├áy c├╣ng Hepazime gi├║p c├í ─én khß╗Åe. Sung. B├│ng ─æß║╣p. Kß║┐t hß╗úp khi d├╣ng vi sinh Eco bac hay Envibac ...\r\n	20231013_vs2rMWvbrw.png	2025-06-05	10	260000
11	Elbagin	Elbagin Tetra Nhß║¡t si├¬u d╞░ß╗íng c├í cß║únh, chß╗æng stress, hß║ín chß║┐ nhiß╗àm khuß║⌐n 	elbagin-tetra-nhat-duong-ca-moi-cho-ca-canh.webp	2025-07-10	10	350000
12	Nuti Grow	Th├║c ─æß║⌐y qu├í tr├¼nh t─âng tr╞░ß╗ƒng, ph├ít triß╗ân mß║ính khung x╞░╞íng	Nuti-Grow.jpg	2025-02-27	10	748000
13	MMS	G├óy m├¬ c├í cß║únh	mms.webp	2026-06-10	10	150000
\.


--
-- Data for Name: productsnuoc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productsnuoc (id, name, ghichu, image_path, hansudung, soluong, price) FROM stdin;
1	EMZEO	EMZEO c├í cß║únh l├á mß╗Öt chß║┐ phß║⌐m vi sinh sß╗¡ dß╗Ñng ─æß╗â xß╗¡ l├╜ n╞░ß╗¢c hß╗ô c├í cß║únh, c├í koi.	emzeo.webp	2025-12-31	5	35000
2	Extra Bio	Ph├ón hß╗ºy c├íc chß║Ñt hß╗»u c╞í trong n╞░ß╗¢c\r\nL├ám sß║ích b├╣n ─æ├íy hß╗ô\r\nKhß╗¡ tr├╣ng n╞░ß╗¢c	extrabio.webp	2025-10-15	10	85000
3	Vi sinh PSB	T─âng c╞░ß╗¥ng khß║ú n─âng tß╗▒ l├ám sß║ích cß╗ºa n╞░ß╗¢c\r\nC├ón bß║▒ng pH, hß║ín chß║┐ sß╗▒ ph├ít triß╗ân cß╗ºa tß║úo\r\nK├¡ch th├¡ch sß╗▒ ph├ón hß╗ºy chß║Ñt hß╗»u c╞í	psb.jpg	2025-10-15	10	60000
4	Jin Di	Ng─ân ngß╗½a sß╗▒ ph├ít triß╗ân cß╗ºa tß║úo, vi khuß║⌐n\r\nGiß║úm l╞░ß╗úng m├╣n b├ú hß╗»u c╞í\r\nGi├║p n╞░ß╗¢c lu├┤n trong l├ánh	jindi.webp	2025-10-15	10	10000
5	EMKOI	T─âng c╞░ß╗¥ng khß║ú n─âng tß╗▒ l├ám sß║ích cß╗ºa hß╗ô c├í\r\nXß╗¡ l├╜ nhanh l╞░ß╗úng amoni, nitrit\r\nNg─ân ngß╗½a bß╗çnh cho c├í	emkoi.jpeg	2025-10-15	10	185000
6	Compozyme	Cß║úi thiß╗çn chß║Ñt l╞░ß╗úng n╞░ß╗¢c\r\nPh├ón hß╗ºy c├íc chß║Ñt hß╗»u c╞í hiß╗çu quß║ú\r\nDuy tr├¼ m├┤i tr╞░ß╗¥ng ß╗òn ─æß╗ïnh cho c├í	compozyme.jpeg	2025-10-15	10	30000
7	EM AQUA	Chß║┐ phß║⌐m sinh hß╗ìc EM AQUA C├í Koi l├á men vi sinh chuy├¬n d├╣ng cß║úi tß║ío chß║Ñt l╞░ß╗úng n╞░ß╗¢c hß╗ô nu├┤i, kiß╗âm so├ít tß║úo, cß║úi tß║ío m├áu n╞░ß╗¢c,ΓÇª\r\n	emaqua.png	2025-06-11	10	71000
8	BIO- FISH KOI	L├ám Trong n╞░ß╗¢c, lß╗ìc n╞░ß╗¢c cho bß╗â c├í, hß╗ô c├í Koi	biofish.jpeg	2025-07-10	10	250000
9	DOBIO KOI	C├│ t├íc dß╗Ñng mß║ính mß║╜ trong viß╗çc l├ám trong n╞░ß╗¢c, xß╗¡ l├╜ kh├¡ ─æß╗Öc, ph├ón hß╗ºy m├╣n b├ú hß╗»u c╞í, giß║úm m├╣i h├┤i cho c├íc ao bß╗â nu├┤i c├í cß║únh, c├í Koi, c├í Ch├⌐p,... 	dobio-koi.webp	2025-10-15	10	165000
10	 ANIRAT	ANIRAT-DOPA THUß╗ÉC THß╗ªY Sß║óN DIß╗åT Tß║ñT Cß║ó C├üC LOß║áI Nß║ñM: Nß║ñM NHß╗ÜT, Nß║ñM THß╗ªY MI, Nß║ñM B├öNG G├ÆNΓÇª 	anirat.webp	2025-06-04	10	489000
11	Detox W+	Detox W+ 500ml khß╗¡ Clo, Clorine giß║úm kim loß║íi nß║╖ng hß╗ô c├í Koi, hß╗ô c├í cß║únh ngay lß║¡p tß╗⌐c 	detox.webp	2025-06-11	10	100000
\.


--
-- Data for Name: thongtinca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.thongtinca (id, name, ghichu, image_path1, image_path2, image_path3, image_path4, khainiem, dacdiem, dinhduong, phanloai, phanbiet) FROM stdin;
17	Yamato Nishiki\t	Koi ├ính kim Yamato\t	YamatoNishiki.jpg	\N	\N	\N	C├í nß╗ün trß║»ng vß╗¢i ─æß╗æm ├ính kim ─æß╗Å v├á ─æen, l├á loß║íi Sanke ├ính kim.\t	C├íc ─æß╗æm ─æß╗Å v├á ─æen tr├¬n nß╗ün trß║»ng, vß║úy ├ính kim, thuß╗Öc hß╗ì Sanke.\t	Thß╗⌐c ─ân chß╗⌐a kho├íng ─æß╗â duy tr├¼ ├ính kim.\t	Yamato Nishiki\t	Dß╗à nhß║¡n biß║┐t nhß╗¥ m├áu sß║»c giß╗æng Sanke nh╞░ng c├│ ├ính kim.\r\n
18	Kanoko koi\t	Koi hoa v─ân Kanoko\t	Kanokokoi.jpg	\N	\N	\N	C├í c├│ hß╗ìa tiß║┐t giß╗æng da h╞░╞íu (kanoko trong tiß║┐ng Nhß║¡t l├á ΓÇ£h╞░╞íuΓÇ¥).\t	─Éß╗æm ─æß╗Å xuß║Ñt hiß╗çn ß╗ƒ v├╣ng th├ón hoß║╖c ─æß║ºu c├│ c├íc chß║Ñm trß║»ng nhß╗Å, tr├┤ng giß╗æng nh╞░ da h╞░╞íu.\t	Thß╗⌐c ─ân duy tr├¼ m├áu sß║»c tß╗▒ nhi├¬n.\t	Kanoko Kohaku\t	Dß╗à ph├ón biß╗çt nhß╗¥ hoa v─ân chß║Ñm tr├▓n trß║»ng nhß╗Å, kh├┤ng phß╗ò biß║┐n nh╞░ c├íc loß║íi koi kh├íc.\r\n
4	Kohaku\t	Koi trß║»ng ─æß╗Å\t	kohaku.jpg	\N	\N	\N	C├í koi m├áu trß║»ng vß╗¢i c├íc ─æß╗æm ─æß╗Å.\t	Phß║ºn nß╗ün trß║»ng s├íng, c├íc ─æß╗æm ─æß╗Å r├╡ n├⌐t v├á ─æß║╣p mß║»t.\t	─én ─æa dß║íng thß╗⌐c ─ân vi├¬n, c├ím, rau xanh.\t	Koi truyß╗ün thß╗æng\t	Kh├┤ng c├│ ─æß╗æm ─æen, m├áu trß║»ng ─æß╗Å ─æß║╖c tr╞░ng.\r\n
5	Utsuri	Koi ─æen\t	utsuri.jpg	\N	\N	\N	C├í c├│ m├áu nß╗ün ─æen vß╗¢i c├íc ─æß╗æm ─æß╗Å, trß║»ng hoß║╖c v├áng.\t	Th├ón ─æen vß╗¢i c├íc ─æß╗æm m├áu sß║»c kh├íc nhau, tß║ío ─æß╗Ö t╞░╞íng phß║ún cao.\t	Thß╗⌐c ─ân vi├¬n, t─âng c╞░ß╗¥ng ─æß║ím.\t	Shiro Utsuri, Hi Utsuri\t	Dß╗à ph├ón biß╗çt bß╗ƒi th├ón ─æen, kh├íc vß╗¢i Showa c├│ th├¬m v├óy ─æß╗æm trß║»ng.\r\n
6	Bekko	Koi ─æen ─æß╗æm\t	bekko.jpg	\N	\N	\N	C├í nß╗ün trß║»ng, v├áng hoß║╖c ─æß╗Å vß╗¢i c├íc ─æß╗æm ─æen.\t	─Éß╗æm ─æen trß║úi ─æß╗üu, kh├┤ng c├│ ─æß╗æm ─æß╗Å.\t	Thß╗⌐c ─ân chß╗⌐a m├áu tß╗▒ nhi├¬n.\t	Shiro Bekko, Aka Bekko\t	Kh├íc Utsuri v├¼ kh├┤ng c├│ nß╗ün ─æen m├á l├á nß╗ün trß║»ng, v├áng hoß║╖c ─æß╗Å.\r\n
7	Asagi	Koi xanh l╞░ß╗¢i\t	asagi.jpeg	\N	\N	\N	C├í nß╗ün xanh x├ím vß╗¢i vß║úy xanh l╞░ß╗¢i, phß║ºn bß╗Ñng ─æß╗Å cam.\t	Vß║úy tr├¬n l╞░ng tß║ío hoa v─ân giß╗æng l╞░ß╗¢i, ─æu├┤i v├á bß╗Ñng th╞░ß╗¥ng c├│ m├áu ─æß╗Å cam.\t	C├ím c├│ m├áu tß╗▒ nhi├¬n ─æß╗â giß╗» m├áu sß║»c ─æß║╣p.\t	Asagi	Vß║úy l╞░ng ─æß║╖c tr╞░ng h├¼nh l╞░ß╗¢i, kh├íc biß╗çt vß╗¢i c├íc koi c├│ ─æß╗æm tr├¬n nß╗ün trß║»ng.\r\n
8	Shusui	Koi kh├┤ng vß║úy\t	shusui.webp	\N	\N	\N	C├í Asagi phi├¬n bß║ún kh├┤ng vß║úy.\t	C├│ ─æ╞░ß╗¥ng vß║úy lß╗¢n dß╗ìc theo l╞░ng, bß╗Ñng m├áu ─æß╗Å cam, kh├┤ng c├│ vß║úy dß╗ìc th├ón.\t	Thß╗⌐c ─ân t─âng c╞░ß╗¥ng protein v├á kho├íng.\t	Shusui	Ph├ón biß╗çt bß╗ƒi kh├┤ng vß║úy tr├¬n th├ón, chß╗ë c├│ vß║úy dß╗ìc l╞░ng.\r\n
2	Showa	Showa Sanshoku	showa2.jpg	showa1.webp	showa3.webp	showa4.jpg	Showa l├á mß╗Öt loß║íi c├í ch├⌐p cß║únh ( c├í ch├⌐p ). Showa c├▓n ─æ╞░ß╗úc gß╗ìi l├á Showa Sanshoku (µÿ¡σÆîΣ╕ëΦë▓)	Showa c├│ th├ón m├áu ─æen (sumi), vß╗¢i c├íc mß║úng m├áu ─æß╗Å (hi) v├á trß║»ng (shiro) tr├¬n khß║»p th├ón.	C├í Koi Showa cß║ºn thß╗⌐c ─ân gi├áu protein ─æß╗â ph├ít triß╗ân c╞í bß║»p v├á t─âng tr╞░ß╗ƒng ─æß╗üu ─æß║╖n. Ngo├ái ra, cß║ºn bß╗ò sung vitamin, kho├íng chß║Ñt ─æß╗â t─âng sß╗⌐c ─æß╗ü kh├íng v├á giß╗» m├áu sß║»c t╞░╞íi s├íng.\t	C├í Koi Showa thuß╗Öc d├▓ng c├í Koi truyß╗ün thß╗æng vß╗¢i ba m├áu chß╗º ─æß║ío: ─æen, trß║»ng v├á ─æß╗Å. ─Éß║╖c biß╗çt, Showa c├│ phß║ºn nß╗ün ─æen vß╗¢i c├íc mß║úng trß║»ng v├á ─æß╗Å nß╗òi bß║¡t tr├¬n c╞í thß╗â.\t	C├í Koi Showa th╞░ß╗¥ng bß╗ï nhß║ºm vß╗¢i Sanke, nh╞░ng ─æiß╗âm kh├íc biß╗çt l├á Showa c├│ nß╗ün ─æen bao phß╗º khß║»p c╞í thß╗â, trong khi Sanke chß╗ë c├│ ─æß╗æm ─æen nhß╗Å ß╗ƒ tr├¬n l╞░ng.\r\n
3	Tancho	Koi Tancho\t	tancho.jpg	\N	\N	\N	C├í c├│ mß╗Öt ─æß╗æm ─æß╗Å tr├▓n tr├¬n ─æß║ºu.\t	Th├ón trß║»ng, kh├┤ng c├│ ─æß╗æm n├áo kh├íc ngo├ái ─æß╗æm tr├▓n ─æß╗Å tr├¬n ─æß║ºu.\t	Thß╗⌐c ─ân c├ón bß║▒ng dinh d╞░ß╗íng ─æß╗â giß╗» m├áu.\t	Tancho Kohaku, Tancho Sanke\t	Dß║Ñu chß║Ñm ─æß╗Å tr├▓n tr├¬n ─æß║ºu l├á ─æß║╖c ─æiß╗âm nß╗òi bß║¡t.\r\n
1	Sanke	Taisho Sanke 	sanke.jpg	koi_sanke1.jpeg	koi_sanke3.jpg	koi_sanke4.jpeg	c├í koi Sanke c├▓n mang theo mß╗Öt ├╜ ngh─⌐a s├óu sß║»c trong v─ân h├│a Nhß║¡t Bß║ún. M├áu trß║»ng cß╗ºa th├ón c├í th╞░ß╗¥ng ─æ╞░ß╗úc li├¬n kß║┐t vß╗¢i sß╗▒ trong s├íng v├á thanh khiß║┐t, trong khi m├áu ─æß╗Å biß╗âu hiß╗çn sß╗⌐c mß║ính v├á sß╗▒ may mß║»n, v├á m├áu ─æen thß╗â hiß╗çn sß╗▒ ki├¬n nhß║½n v├á sß╗▒ cß╗⌐ng cß╗Åi. Do ─æ├│, Sanke th╞░ß╗¥ng ─æ╞░ß╗úc coi l├á biß╗âu t╞░ß╗úng cß╗ºa sß╗▒ c├ón bß║▒ng v├á may mß║»n trong t╞░ duy phong thß╗ºy.	C├í koi Sanke vß╗¢i m├áu trß║»ng trong trß║╗o cß╗ºa th├ón c├í, kß║┐t hß╗úp vß╗¢i c├íc vß╗çt m├áu ─æß╗Å v├á ─æen tß║ío th├ánh c├íc hoa v─ân phß╗⌐c tß║íp. Mß╗ùi mß╗Öt vß╗çt m├áu ─æß╗Å v├á ─æen tr├¬n th├ón c├í Sanke ─æß╗üu ─æ╞░ß╗úc tß║ío ra mß╗Öt c├ích tß╗ë mß╗ë v├á c├ón nhß║»c, tß║ío ra mß╗Öt bß╗⌐c tranh sß╗æng ─æß╗Öng v├á l├┤i cuß╗æn khi Sanke b╞íi trong n╞░ß╗¢c.	C├í Koi Sanke cß║ºn chß║┐ ─æß╗Ö dinh d╞░ß╗íng c├ón bß║▒ng gß╗ôm protein, vitamin, v├á kho├íng chß║Ñt. Thß╗⌐c ─ân dß║íng vi├¬n hoß║╖c thß╗⌐c ─ân t╞░╞íi sß╗æng gi├║p duy tr├¼ m├áu sß║»c v├á sß╗⌐c khß╗Åe cß╗ºa c├í.	C├í Koi Sanke c├│ thß╗â ─æ╞░ß╗úc ph├ón loß║íi dß╗▒a v├áo k├¡ch th╞░ß╗¢c, h├¼nh d├íng ─æß╗æm ─æß╗Å v├á ─æen tr├¬n c╞í thß╗â, v├á mß╗⌐c ─æß╗Ö tinh khiß║┐t cß╗ºa m├áu trß║»ng.	Ph├ón biß╗çt vß╗¢i Showa Koi: Sanke kh├┤ng c├│ ─æß╗æm ─æen tr├¬n ─æß║ºu v├á ├¡t Sumi h╞ín. Showa Koi c├│ nhiß╗üu Sumi, bao gß╗ôm cß║ú tr├¬n ─æß║ºu. Sanke th╞░ß╗¥ng c├│ m├áu trß║»ng nhiß╗üu h╞ín Showa.
9	Goromo	Koi viß╗ün m├áu\t	goromo.webp	\N	\N	\N	C├í nß╗ün trß║»ng vß╗¢i c├íc ─æß╗æm m├áu viß╗ün xanh hoß║╖c ─æen.\t	C├íc ─æß╗æm c├│ viß╗ün xanh hoß║╖c t├¡m ─æß║¡m, tß║ío vß║╗ ngo├ái ─æß╗Öc ─æ├ío.\t	─én ─æa dß║íng, t─âng c╞░ß╗¥ng ─æß║ím cho m├áu sß║»c.\t	Ai Goromo, Budo Goromo\t	Dß╗à nhß║¡n biß║┐t nhß╗¥ viß╗ün xanh hoß║╖c t├¡m ß╗ƒ c├íc ─æß╗æm m├áu ─æß╗Å tr├¬n th├ón.\r\n
10	Kin/Ginrin\t	Koi ├ính kim\t	kinginrin.jpg	\N	\N	\N	C├í c├│ vß║úy ├ính kim (kin l├á ├ính v├áng, gin l├á ├ính bß║íc).\t	Vß║úy ├│ng ├ính nh╞░ kim loß║íi, c├│ thß╗â l├á ├ính bß║íc hoß║╖c ├ính v├áng.\t	Thß╗⌐c ─ân chß╗⌐a kho├íng ─æß╗â giß╗» vß║úy ├ính kim.\t	Ginrin Kohaku, Ginrin Sanke\t	Dß╗à ph├ón biß╗çt nhß╗¥ vß║úy ├ính kim nß╗òi bß║¡t, c├│ thß╗â kß║┐t hß╗úp vß╗¢i nhiß╗üu loß║íi koi kh├íc.\r\n
11	Goshiki	Koi ─æa sß║»c\t	goshiki.webp	\N	\N	\N	C├í nß╗ün x├ím vß╗¢i c├íc ─æß╗æm ─æß╗Å v├á ─æen.\t	Th├ón m├áu x├ím ─æen v├á c├│ ─æß╗æm ─æß╗Å, kß║┐t hß╗úp nhiß╗üu lß╗¢p m├áu sß║»c.\t	Thß╗⌐c ─ân duy tr├¼ m├áu tß╗▒ nhi├¬n, ─æa dß║íng.\t	Goshiki	Dß╗à nhß║¡n biß║┐t bß╗ƒi lß╗¢p m├áu nß╗ün pha lß║½n ─æß╗Å, ─æen v├á x├ím.\r\n
12	Hikarimuji	Koi ├ính kim ─æ╞ín sß║»c\t	Hikarimuji.webp	\N	\N	\N	C├í c├│ th├ón m├áu ├ính kim loß║íi ─æ╞ín sß║»c (v├áng, bß║íc).\t	M├áu sß║»c ─æß╗ông ─æß╗üu, s├íng b├│ng, th╞░ß╗¥ng l├á v├áng hoß║╖c bß║íc, tß║ío vß║╗ ─æß║╣p sang trß╗ìng.\t	Thß╗⌐c ─ân chß╗⌐a kho├íng gi├║p s├íng m├áu.\t	Hikarimuji	M├áu sß║»c kim loß║íi ─æ╞ín sß║»c, kh├íc vß╗¢i Hikarimoyo c├│ nhiß╗üu m├áu.\r\n
13	Hikarimoyo	Koi ├ính kim hß╗ìa tiß║┐t\t	hikarimoyo.jpeg	\N	\N	\N	C├í c├│ th├ón m├áu ├ính kim loß║íi v├á hoa v─ân ─æß╗æm nhiß╗üu m├áu.\t	Phß╗æi m├áu ─æa dß║íng tr├¬n nß╗ün kim loß║íi, c├│ thß╗â kß║┐t hß╗úp ─æß╗Å, ─æen, v├áng.\t	Thß╗⌐c ─ân cho c├í ├ính kim gi├║p giß╗» m├áu.\t	Hikarimoyo	Kh├íc vß╗¢i Hikarimuji ß╗ƒ chß╗ù c├│ th├¬m c├íc hoa v─ân, ─æß╗æm m├áu tr├¬n nß╗ün ├ính kim.\r\n
14	Hikariutsuri	Koi ├ính kim Utsuri\t	HikariUtsuri.webp	\N	\N	\N	C├í c├│ nß╗ün ─æen kß║┐t hß╗úp vß╗¢i m├áu ├ính kim.\t	Nß╗ün ─æen vß╗¢i c├íc ─æß╗æm m├áu v├áng hoß║╖c bß║íc ├ính kim, tß║ío vß║╗ ngo├ái ß║Ñn t╞░ß╗úng.\t	Thß╗⌐c ─ân t─âng c╞░ß╗¥ng ├ính kim.\t	Hikariutsuri	Kh├íc vß╗¢i Utsuri nhß╗¥ lß╗¢p ├ính kim, vß║úy s├íng b├│ng.\r\n
15	Kawarimono\t	Koi ─æa dß║íng\t	kawarimono.webp	\N	\N	\N	Nh├│m c├í koi kh├┤ng ph├ón loß║íi v├áo c├íc nh├│m koi truyß╗ün thß╗æng.\t	C├íc loß║íi koi c├│ m├áu sß║»c hoß║╖c hoa v─ân kh├┤ng theo quy tß║»c nhß║Ñt ─æß╗ïnh, ─æß╗Öc ─æ├ío.\t	Thß╗⌐c ─ân c├ón bß║▒ng gi├║p c├í ph├ít triß╗ân tß╗æt.\t	Kawarimono	Kh├│ ph├ón biß╗çt, kh├┤ng c├│ quy tß║»c cß╗æ ─æß╗ïnh vß╗ü m├áu sß║»c, hß╗ìa tiß║┐t.\r\n
16	Doitsu koi\t	Koi kh├┤ng vß║úy\t	doitsu.jpg	\N	\N	\N	C├í koi kh├┤ng c├│ vß║úy hoß║╖c c├│ vß║úy dß╗ìc l╞░ng.\t	Th├ón tr╞ín l├íng hoß║╖c chß╗ë c├│ mß╗Öt d├úy vß║úy dß╗ìc l╞░ng, mang vß║╗ ngo├ái ─æß╗Öc ─æ├ío.\t	Thß╗⌐c ─ân nhß║╣, kh├┤ng t─âng c╞░ß╗¥ng m├áu sß║»c.\t	Doitsu Kohaku, Doitsu Sanke\t	Ph├ón biß╗çt qua ─æß║╖c ─æiß╗âm kh├┤ng vß║úy hoß║╖c chß╗ë c├│ vß║úy ß╗ƒ l╞░ng, th╞░ß╗¥ng l├á giß╗æng Kohaku hoß║╖c Sanke.\r\n
\.


--
-- Data for Name: thongtinho; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.thongtinho (id, name, mota, ghichu, loai, kichthuoc, nhungcayphu, loaicaphuhop, image_path1, image_path2, image_path3, image_path4) FROM stdin;
2	Hß╗ô Koi trong nh├á	Hß╗ô Koi trong nh├á l├á giß║úi ph├íp ho├án hß║úo cho nhß╗»ng ai muß╗æn mang thi├¬n nhi├¬n v├áo kh├┤ng gian sß╗æng cß╗ºa m├¼nh m├á kh├┤ng cß║ºn lo lß║»ng vß╗ü thß╗¥i tiß║┐t. Hß╗ô Koi trong nh├á th╞░ß╗¥ng c├│ hß╗ç thß╗æng lß╗ìc n╞░ß╗¢c kh├⌐p k├¡n, ─æß║úm bß║úo n╞░ß╗¢c lu├┤n sß║ích sß║╜ v├á trong l├ánh. Nhß╗»ng hß╗ô n├áy kh├┤ng chß╗ë l├á ─æiß╗âm nhß║Ñn trang tr├¡ tuyß╗çt ─æß║╣p, m├á c├▓n tß║ío ra kh├┤ng gian y├¬n t─⌐nh v├á th╞░ gi├ún trong nh├á. ─Éß║╖c biß╗çt, hß╗ô Koi trong nh├á c├│ thß╗â ─æ╞░ß╗úc trang tr├¡ bß║▒ng hß╗ç thß╗æng ├ính s├íng ─æ├¿n LED ─æß╗â l├ám nß╗òi bß║¡t vß║╗ ─æß║╣p cß╗ºa c├í Koi v├áo ban ─æ├¬m.	V├¼ hß╗ô Koi trong nh├á kh├┤ng phß║úi chß╗ïu ß║únh h╞░ß╗ƒng cß╗ºa c├íc yß║┐u tß╗æ m├┤i tr╞░ß╗¥ng nh╞░ ├ính nß║»ng mß║╖t trß╗¥i hay m╞░a, n├¬n viß╗çc ch─âm s├│c c├í trß╗ƒ n├¬n dß╗à d├áng h╞ín. Tuy nhi├¬n, kh├┤ng gian hß╗ô c├│ thß╗â bß╗ï hß║ín chß║┐ so vß╗¢i hß╗ô ngo├ái trß╗¥i, do ─æ├│ cß║ºn chß╗ìn k├¡ch th╞░ß╗¢c hß╗ô ph├╣ hß╗úp vß╗¢i kh├┤ng gian ng├┤i nh├á. Viß╗çc thiß║┐t kß║┐ hß╗ç thß╗æng lß╗ìc v├á ─æiß╗üu h├▓a n╞░ß╗¢c c┼⌐ng cß║ºn ─æ╞░ß╗úc quan t├óm ─æß║╖c biß╗çt ─æß╗â ─æß║úm bß║úo c├í Koi sß╗æng trong ─æiß╗üu kiß╗çn tß╗æt nhß║Ñt.	Hß╗ô trong nh├á	3m x 2m x 1m	C├óy thß╗ºy sinh nh╞░ rong, lß╗Ñc b├¼nh v├á mß╗Öt sß╗æ c├óy nhß╗Å trang tr├¡ nh╞░ trß║ºu b├á, c├óy ─æu├┤i c├┤ng.	Koi ─Éen, Koi Trß║»ng	ho2_img1.jpg	ho2_img2.jpg	ho2_img3.jpg	ho2_img4.jpg
6	Hß╗ô c├í koi biß╗çt thß╗▒	Xu h╞░ß╗¢ng thi c├┤ng hß╗ô c├í koi trong s├ón v╞░ß╗¥n biß╗çt thß╗▒ cao cß║Ñp hiß╗çn ─æang ─æ╞░ß╗úc nhiß╗üu ng╞░ß╗¥i ╞░a chuß╗Öng. Chß╗ë cß║ºn ngß╗ôi trong ph├▓ng kh├ích ngß║»m nh├¼n ─æ├án c├í b╞íi lß╗Öi, gia chß╗º c┼⌐ng cß║úm nhß║¡n ─æ╞░ß╗úc sß╗▒ b├¼nh y├¬n v├á an t─⌐nh.	Hß╗ô cß║ºn ─æ╞░ß╗úc thiß║┐t kß║┐ ─æß╗º s├óu, ├¡t nhß║Ñt 1,5 - 2m, ─æß╗â c├í Koi c├│ kh├┤ng gian b╞íi thoß║úi m├íi v├á tr├ính biß║┐n ─æß╗Öng nhiß╗çt ─æß╗Ö.\r\nVß╗ï tr├¡ ─æß║╖t hß╗ô n├¬n tr├ính ├ính nß║»ng mß║╖t trß╗¥i trß╗▒c tiß║┐p qu├í l├óu, gi├║p hß║ín chß║┐ r├¬u tß║úo ph├ít triß╗ân v├á duy tr├¼ nhiß╗çt ─æß╗Ö n╞░ß╗¢c ß╗òn ─æß╗ïnh.	Hß╗ô biß╗çt thß╗▒	3m x 5m x 1.5m 	C├óy thß╗ºy tr├║c, C├óy l╞░ß╗íi m├íc, Hoa sen, hoa s├║ng	Kohaku, Taisho Sanke, Showa Sanshoku, Shiro Utsuri, Hi Utsuri, Chagoi, Ogon, Asagi, Doitsu Koi.	hobietthu.jpg	\N	\N	\N
1	Hß╗ô Koi ngo├ái trß╗¥i	Hß╗ô Koi ngo├ái trß╗¥i l├á mß╗Öt lß╗▒a chß╗ìn tuyß╗çt vß╗¥i cho nhß╗»ng ng╞░ß╗¥i muß╗æn tß║¡n dß╗Ñng kh├┤ng gian s├ón v╞░ß╗¥n hoß║╖c khu vß╗▒c ngo├ái trß╗¥i rß╗Öng r├úi. Hß╗ô th╞░ß╗¥ng ─æ╞░ß╗úc thiß║┐t kß║┐ vß╗¢i hß╗ç thß╗æng lß╗ìc n╞░ß╗¢c tß╗▒ ─æß╗Öng v├á khß║ú n─âng chß╗æng chß╗ïu thß╗¥i tiß║┐t khß║»c nghiß╗çt. Nhß╗»ng hß╗ô n├áy th╞░ß╗¥ng ─æ╞░ß╗úc bao quanh bß╗ƒi c├íc c├óy xanh lß╗¢n, tß║ío m├┤i tr╞░ß╗¥ng m├ít mß║╗, tho├íng ─æ├úng, v├á gi├║p c├í Koi ph├ít triß╗ân mß║ính mß║╜. C├íc d├▓ng suß╗æi nhß╗Å hoß║╖c th├íc n╞░ß╗¢c nh├ón tß║ío c┼⌐ng c├│ thß╗â ─æ╞░ß╗úc th├¬m v├áo ─æß╗â t─âng t├¡nh thß║⌐m mß╗╣ v├á sß╗▒ th╞░ gi├ún.	Hß╗ô Koi ngo├ái trß╗¥i c├│ lß╗úi thß║┐ lß╗¢n l├á c├│ thß╗â kß║┐t hß╗úp vß╗¢i ├ính s├íng tß╗▒ nhi├¬n v├á kh├¡ hß║¡u cß╗ºa v├╣ng miß╗ün, gi├║p c├í ph├ít triß╗ân tß╗æt h╞ín. Tuy nhi├¬n, cß║ºn ch├║ ├╜ ─æß║┐n viß╗çc bß║úo tr├¼ v├á quß║ún l├╜ hß╗ç thß╗æng lß╗ìc n╞░ß╗¢c ─æß╗â ─æß║úm bß║úo n╞░ß╗¢c lu├┤n trong sß║ích v├á kh├┤ng bß╗ï ├┤ nhiß╗àm. Viß╗çc kiß╗âm tra chß║Ñt l╞░ß╗úng n╞░ß╗¢c ─æß╗ïnh kß╗│ c┼⌐ng rß║Ñt quan trß╗ìng ─æß╗â ─æß║úm bß║úo sß╗⌐c khß╗Åe cß╗ºa c├í Koi trong m├┤i tr╞░ß╗¥ng tß╗▒ nhi├¬n.	Hß╗ô ngo├ái trß╗¥i	4m x 3m x 1.5m	C├óy cß║únh lß╗¢n nh╞░ b├ích, t├╣ng, sen ─æ├í v├á hoa s├║ng ─æß║╖t xung quanh hß╗ô tß║ío kh├┤ng gian xanh m├ít.	Koi ─Éen, Koi ─Éß╗Å, Koi V├áng, Koi Trß║»ng	hongoaitroi.jpg	ho1_img2.jpg	ho1_img3.jpg	ho1_img4.jpg
5	Hß╗ô Koi s├ón v╞░ß╗¥n	Hß╗ô Koi s├ón v╞░ß╗¥n l├á mß╗Öt kh├┤ng gian n╞░ß╗¢c trang tr├¡ ─æ╞░ß╗úc thiß║┐t kß║┐ ─æß╗â nu├┤i d╞░ß╗íng c├í Koi, th╞░ß╗¥ng ─æ╞░ß╗úc kß║┐t hß╗úp vß╗¢i c├íc yß║┐u tß╗æ thi├¬n nhi├¬n nh╞░ c├óy cß╗æi, ─æ├í, v├á ─æ├¿n chiß║┐u s├íng. Hß╗ô n├áy kh├┤ng chß╗ë tß║ío ra m├┤i tr╞░ß╗¥ng sß╗æng cho c├í Koi m├á c├▓n l├ám t─âng t├¡nh thß║⌐m mß╗╣ cho khu v╞░ß╗¥n, mang lß║íi cß║úm gi├íc y├¬n b├¼nh v├á th╞░ gi├ún.	Hß╗ô n├¬n ─æ╞░ß╗úc x├óy dß╗▒ng vß╗¢i lß╗¢p ─æ├íy d├áy v├á hß╗ç thß╗æng lß╗ìc n╞░ß╗¢c hiß╗çu quß║ú ─æß╗â giß╗» n╞░ß╗¢c lu├┤n sß║ích sß║╜.\r\nCß║ºn ch├║ ├╜ ─æß║┐n ─æß╗Ö s├óu cß╗ºa hß╗ô ─æß╗â c├í Koi c├│ ─æß╗º kh├┤ng gian b╞íi lß╗Öi v├á ph├ít triß╗ân.\r\nN├¬n c├│ b├│ng r├óm tß╗½ c├óy cß╗æi hoß║╖c m├íi che ─æß╗â c├í kh├┤ng bß╗ï ├ính nß║»ng mß║╖t trß╗¥i chiß║┐u trß╗▒c tiß║┐p qu├í nhiß╗üu, gi├║p duy tr├¼ nhiß╗çt ─æß╗Ö n╞░ß╗¢c ß╗òn ─æß╗ïnh.	Hß╗ô s├ón v╞░ß╗¥n	3m x 2m x 1m 	C├óy thß╗ºy sinh: R├¬u, b├¿o t├óy, ngß╗ìc nß╗». Nhß╗»ng c├óy n├áy gi├║p cß║úi thiß╗çn chß║Ñt l╞░ß╗úng n╞░ß╗¢c v├á tß║ío n╞íi tr├║ ß║⌐n cho c├í.\r\nC├óy cß║únh: Sen, s├║ng n╞░ß╗¢c, v├á c├óy thß║úo mß╗Öc nh╞░ h├║ng quß║┐ hoß║╖c bß║íc h├á c├│ thß╗â trß╗ông xung quanh hß╗ô ─æß╗â tß║ío cß║únh quan ─æß║╣p mß║»t.	C├í Koi (Nhiß╗üu giß╗æng nh╞░ Kohaku, Sanke, Showa)\r\nC├í v├áng (Goldfish) c├│ thß╗â ─æ╞░ß╗úc th├¬m v├áo ─æß╗â tß║ío sß╗▒ ─æa dß║íng.\r\n	hokoisanvuon1.jpg	hokoisanvuon2.jpg	hokoisanvuon3.png	hokoisanvuon4.jpg
8	Hß╗ô c├í koi mini	Hß╗ô c├í Koi mini th╞░ß╗¥ng ─æ╞░ß╗úc thiß║┐t kß║┐ cho kh├┤ng gian nhß╗Å, s├ón v╞░ß╗¥n nhß╗Å hoß║╖c trong nh├á. Chß╗⌐a c├íc yß║┐u tß╗æ thß║⌐m mß╗╣ nh╞░ ─æ├í trang tr├¡ v├á c├óy thß╗ºy sinh nhß║╣.\t	─Éß║úm bß║úo hß╗ç thß╗æng lß╗ìc n╞░ß╗¢c tß╗æt ─æß╗â giß╗» n╞░ß╗¢c sß║ích v├á oxy h├│a ß╗òn ─æß╗ïnh, tr├ính t├¼nh trß║íng ├┤ nhiß╗àm.\t	Hß╗ô mini	2m x 1.5m x 1m	D╞░╞íng xß╗ë, rong ─æu├┤i chß╗ôn, c├óy b├¿o Nhß║¡t. C├óy sen mini, c├óy s├║ng nhß╗Å	C├íc loß║íi c├í Koi mini hoß║╖c c├í Koi nhß╗Å c├│ k├¡ch th╞░ß╗¢c d╞░ß╗¢i 20 cm ─æß╗â ph├╣ hß╗úp vß╗¢i diß╗çn t├¡ch nhß╗Å cß╗ºa hß╗ô.	homini1.jpg	hocakoimini2.webp	homini3.jpg	homini4.jpg
12	Hß╗ô koi Nhß║¡t Bß║ún\t	Hß╗ô truyß╗ün thß╗æng phong c├ích Nhß║¡t, th╞░ß╗¥ng kß║┐t hß╗úp ─æ├í v├á c├óy cß║únh tß║ío cß║únh quan tß╗▒ nhi├¬n.\t	Thiß║┐t kß║┐ gß║ºn g┼⌐i vß╗¢i thi├¬n nhi├¬n, th╞░ß╗¥ng c├│ dß║íng tr├▓n hoß║╖c tß╗▒ do, kh├┤ng ─æß╗æi xß╗⌐ng.\t	Hß╗ô Nhß║¡t Bß║ún	2m x 3m x 0,8m hoß║╖c lß╗¢n h╞ín\t	Sen mini, hoa s├║ng, thß╗ºy tr├║c mini, lß╗Ñc b├¼nh\t	Kohaku, Taisho Sanke, Showa Sanshoku\r\n	honhatban.jpg	\N	\N	\N
9	Hß╗ô Koi ban c├┤ng	Hß╗ô c├í Koi mini tr├¬n s├ón th╞░ß╗úng, hß╗ô c├í Koi ban c├┤ng l├á ├╜ t╞░ß╗ƒng x├óy dß╗▒ng hß╗ô Koi tuyß╗çt vß╗¥i v├á kh├┤ng k├⌐m phß║ºn t├ío bß║ío. ─Éß║╖c biß╗çt, hß╗ô c├í Koi phong c├ích hiß╗çn ─æß║íi n├áy rß║Ñt th├¡ch hß╗úp vß╗¢i kh├┤ng gian nh├á phß╗æ, biß╗çt thß╗▒.\r\nTrong phong thß╗ºy, tß║ºng th╞░ß╗úng c├│ vai tr├▓ rß║Ñt quan trß╗ìng trong viß╗çc giß╗» ß║⌐m v├á tß║ío bß║ºu kh├┤ng kh├¡ m├ít mß║╗ cho ng├┤i nh├á. B├¬n cß║ính ─æ├│, viß╗çc kß║┐t hß╗úp vß╗¢i c├íc tiß╗âu cß║únh s├┤ng, ao, khe, suß╗æi, th├íc,ΓÇª sß║╜ gi├║p phong thß╗ºy s├ón t╞░ß╗úng h├ái h├▓a h╞ín, h├úm d╞░╞íng s├ít. Do ─æ├│, viß╗çc ─æß║╖t hß╗ô c├í Koi hiß╗çn ─æß║íi tr├¬n tß║ºng th╞░ß╗úng kh├┤ng chß╗ë g├│p phß║ºn tß║ío n├¬n kh├┤ng kh├¡ m├ít mß║╗, dß╗à chß╗ïu m├á c├▓n mang may mß║»n ─æß║┐n gia ─æ├¼nh bß║ín.	Ch├║ ├╜ kß║┐t cß║Ñu chß╗ïu lß╗▒c, chß╗æng thß║Ñm, hß╗ç thß╗æng lß╗ìc n╞░ß╗¢c, ├ính s├íng	Hß╗ô s├ón th╞░ß╗úng, ban c├┤ng	1m x 1m x 0,5m	Hoa s├║ng mini,Lß╗Ñc b├¼nh (b├¿o Nhß║¡t),D╞░╞íng xß╗ë thß╗ºy sinh,Rong ─æu├┤i ch├│,Thß╗ºy tr├║c mini,Sen mini\r\n\r\n	Kohaku,Taisho Sanke,Showa Sanshoku (Showa),Shiro Utsuri,Asagi	hosanthuong.jpg	\N	\N	\N
10	Hß╗ô mini ngo├ái trß╗¥i	Hß╗ô nhß╗Å, th╞░ß╗¥ng ─æ╞░ß╗úc ─æß║╖t ngo├ái trß╗¥i, ph├╣ hß╗úp cho kh├┤ng gian hß║╣p nh╞░ s├ón v╞░ß╗¥n nhß╗Å hoß║╖c ban c├┤ng.\t	Th├¡ch hß╗úp cho ng╞░ß╗¥i mß╗¢i ch╞íi, dß╗à ch─âm s├│c.\t	Hß╗ô mini	1m x 1m x 0,5m; 1m x 1,5m x 0,6m\t	Lß╗Ñc b├¼nh, hoa s├║ng mini, d╞░╞íng xß╗ë thß╗ºy sinh\t	Kohaku, Shiro Utsuri\r\n	hominingoaitroi.jpg	\N	\N	\N
11	Hß╗ô koi bß║▒ng k├¡nh\t	Hß╗ô c├│ th├ánh l├ám bß║▒ng k├¡nh, tß║ío hiß╗çu ß╗⌐ng ─æß║╣p mß║»t, gi├║p dß╗à d├áng quan s├ít c├í.\t	Th╞░ß╗¥ng cß║ºn bß╗æ tr├¡ trong nh├á hoß║╖c c├│ m├íi che ─æß╗â tr├ính ├ính nß║»ng mß║ính l├ám n├│ng n╞░ß╗¢c.\t	Hß╗ô bß║▒ng k├¡nh	1m x 2m x 0,7m hoß║╖c lß╗¢n h╞ín\t	Rong ─æu├┤i ch├│, d╞░╞íng xß╗ë, lß╗Ñc b├¼nh\t	Taisho Sanke, Showa Sanshoku\r\n	hobangkinh.jpg	\N	\N	\N
13	Hß╗ô koi chß╗» U\t	Hß╗ô c├│ h├¼nh dß║íng chß╗» U, ph├╣ hß╗úp vß╗¢i kh├┤ng gian quanh nh├á, gi├║p tiß║┐t kiß╗çm diß╗çn t├¡ch.\t	Thiß║┐t kß║┐ linh hoß║ít, dß╗à bß╗æ tr├¡ ß╗ƒ nhß╗»ng kh├┤ng gian d├ái hoß║╖c g├│c nh├á.\t	Hß╗ô chß╗» U	1,5m x 3m x 0,8m hoß║╖c lß╗¢n h╞ín\t	Thß╗ºy tr├║c mini, d╞░╞íng xß╗ë thß╗ºy sinh, rong ─æu├┤i ch├│\t	Shiro Utsuri, Kohaku\r\n	hochuU.jpg	\N	\N	\N
7	Hß╗ô koi lß╗¢n\t	Hß╗ô rß╗Öng, th├¡ch hß╗úp cho s├ón v╞░ß╗¥n lß╗¢n, tß║ío kh├┤ng gian tß╗▒ nhi├¬n cho c├í ph├ít triß╗ân thoß║úi m├íi.\t	Cß║ºn kh├┤ng gian rß╗Öng v├á khß║ú n─âng chß╗ïu tß║úi tß╗æt, hß╗ç thß╗æng lß╗ìc mß║ính mß║╜.\t	Hß╗ô lß╗¢n	3m x 5m x 1m hoß║╖c lß╗¢n h╞ín\t	Sen, hoa s├║ng lß╗¢n, lß╗Ñc b├¼nh, rong ─æu├┤i ch├│\t	Asagi, Showa Sanshoku, Kohaku\r\n	holon.jpg	\N	\N	\N
4	Hß╗ô koi hiß╗çn ─æß║íi\t	Hß╗ô c├│ thiß║┐t kß║┐ hiß╗çn ─æß║íi, th╞░ß╗¥ng d├╣ng c├íc vß║¡t liß╗çu k├¡nh, th├⌐p kh├┤ng gß╗ë hoß║╖c b├¬ t├┤ng tinh tß║┐.\t	Phong c├ích sang trß╗ìng, th├¡ch hß╗úp cho biß╗çt thß╗▒ hoß║╖c kh├┤ng gian c├│ kiß║┐n tr├║c hiß╗çn ─æß║íi.\t	Hß╗ô hiß╗çn ─æß║íi	2m x 2m x 0,7m hoß║╖c 2m x 3m x 0,8m\t	Lß╗Ñc b├¼nh, d╞░╞íng xß╗ë, c├óy thß╗ºy sinh mini\t	Taisho Sanke, Showa, Shiro Utsuri\r\n	hohiendai.jpg	\N	\N	\N
3	Hß╗ô kß║┐t hß╗úp thang\t	Hß╗ô c├│ thiß║┐t kß║┐ ─æß║╖c biß╗çt vß╗¢i c├íc bß║¡c thang giß╗»a hß╗ô, tß║ío hiß╗çu ß╗⌐ng d├▓ng n╞░ß╗¢c chß║úy tß╗½ bß║¡c n├áy sang bß║¡c kh├íc.\t	Tß║ío kh├┤ng gian sinh ─æß╗Öng, cß║ºn thiß║┐t kß║┐ chß║»c chß║»n v├á ─æß║úm bß║úo khß║ú n─âng chß╗ïu tß║úi tß╗æt cho c├íc bß║¡c thang.\t	Hß╗ô bß║¡c thang	2m x 3m x 0,8m hoß║╖c lß╗¢n h╞ín\t	Lß╗Ñc b├¼nh, d╞░╞íng xß╗ë, rong ─æu├┤i ch├│, c├óy thß╗ºy sinh nhß╗Å\t	Kohaku, Taisho Sanke, Shiro Utsuri\r\n	hokethopthang.jpg	\N	\N	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, email, fullname, address, isadmin, avatar, banned_until) FROM stdin;
2	vu12345	$2a$10$wW//8hXcEUXb08ld9cpZretI34L69qpNeu3LpTOptL5WcIAS.6KI6	hoangvuvo907@gmail.com	V├╡ V┼⌐	440 Thß╗æng Nhß║Ñt	f	\N	\N
1	vu951236	$2a$10$zAZ/MOc64pW3p3oxYFygcuD.Nts/NN.mkf60BaORkqlfSzEJd9k6O	hoangvuvo907@gmail.com	V├╡ V┼⌐	440 Thß╗æng Nhß║Ñt	f	images/avatartest.jpeg	\N
4	vuad951236	$2a$10$WZLFJ7cAdGvBGyMmlR66FeAlKaAvv3yxYeIjHU7a96QxJAk3FWkNi	hoangvuvo907@gmail.com	V├╡ V┼⌐	440 Thß╗æng Nhß║Ñt	t	\N	\N
3	vu951237	$2a$10$Jx7UEQ3qhXcVN3u9JAfDv.DwWcnAOcQonNuVDC2Yl5roPMoAJobqG	hoangvuvo907@gmail.com	V├╡ V┼⌐	440 Thß╗æng Nhß║Ñt	f	\N	\N
5	vu951238	$2a$10$wmB4DMGJ8EL0CbjkBs.UE.lTetS91Io8N1QwEWqQBBAJPl43M8P8a	hoangvuvo907@gmail.com	V├╡ V┼⌐	440 Thß╗æng Nhß║Ñt	t	\N	\N
6	vu951239	$2a$10$k5B/G2apB2DRp1/TFYcmP.d8JuygxTcJSPCxRkEzaOnjKXMaMIWwq	hoangvuvo907@gmail.com	V├╡ V┼⌐	440 Thß╗æng Nhß║Ñt	t	\N	\N
\.


--
-- Name: donhang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donhang_id_seq', 4, true);


--
-- Name: hocacanhan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hocacanhan_id_seq', 12, true);


--
-- Name: productsca_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productsca_id_seq', 1, true);


--
-- Name: productsnuoc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productsnuoc_id_seq', 1, true);


--
-- Name: thongtinca_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.thongtinca_id_seq', 1, false);


--
-- Name: thongtinho_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.thongtinho_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: donhang donhang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donhang
    ADD CONSTRAINT donhang_pkey PRIMARY KEY (id);


--
-- Name: hocacanhan hocacanhan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hocacanhan
    ADD CONSTRAINT hocacanhan_pkey PRIMARY KEY (id);


--
-- Name: idadmin idadmin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idadmin
    ADD CONSTRAINT idadmin_pkey PRIMARY KEY (id);


--
-- Name: productsca productsca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productsca
    ADD CONSTRAINT productsca_pkey PRIMARY KEY (id);


--
-- Name: productsnuoc productsnuoc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productsnuoc
    ADD CONSTRAINT productsnuoc_pkey PRIMARY KEY (id);


--
-- Name: thongtinca thongtinca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thongtinca
    ADD CONSTRAINT thongtinca_pkey PRIMARY KEY (id);


--
-- Name: thongtinho thongtinho_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thongtinho
    ADD CONSTRAINT thongtinho_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- PostgreSQL database dump complete
--

