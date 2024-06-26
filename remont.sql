PGDMP  3                    {            Remont    16.0    16.0 }               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16397    Remont    DATABASE     |   CREATE DATABASE "Remont" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "Remont";
                postgres    false            �            1255    16580 "   get_category_id(character varying)    FUNCTION     .  CREATE FUNCTION public.get_category_id(category_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    cat_id INT;
BEGIN
    SELECT equipment_catid INTO cat_id
    FROM equipment_categories
    WHERE equipment_catname = category_name;

    RETURN cat_id;
END;
$$;
 G   DROP FUNCTION public.get_category_id(category_name character varying);
       public          postgres    false            �            1255    16581 g   insert_into_equipment(character varying, character varying, character varying, date, character varying)    FUNCTION     �  CREATE FUNCTION public.insert_into_equipment(serialnumber character varying, brand character varying, model character varying, acceptancedate date, category_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    cat_id INT;
BEGIN
    -- Получаем equipment_catid для указанного equipment_catname
    cat_id := get_category_id(category_name);

    -- Вставляем новую запись в equipment, используя equipment_catid
    INSERT INTO equipment (serialnumber, brand, model, acceptancedate, category)
    VALUES (serialnumber, brand, model, acceptancedate, cat_id);
END;
$$;
 �   DROP FUNCTION public.insert_into_equipment(serialnumber character varying, brand character varying, model character varying, acceptancedate date, category_name character varying);
       public          postgres    false            �            1255    16579    update_total_cost(integer)    FUNCTION     �   CREATE FUNCTION public.update_total_cost(order_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
        UPDATE orders
        SET totalcost = (partscost + laborcost) * 1.2
        WHERE orderid = order_id;
END;
$$;
 :   DROP FUNCTION public.update_total_cost(order_id integer);
       public          postgres    false            �            1259    16399    clients    TABLE     �   CREATE TABLE public.clients (
    clientid integer NOT NULL,
    lastname character varying(30),
    firstname character varying(30),
    middlename character varying(30),
    mobilephone character(12),
    email character varying(255)
);
    DROP TABLE public.clients;
       public         heap    postgres    false            �            1259    16398    clients_clientid_seq    SEQUENCE     �   CREATE SEQUENCE public.clients_clientid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.clients_clientid_seq;
       public          postgres    false    216            �           0    0    clients_clientid_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.clients_clientid_seq OWNED BY public.clients.clientid;
          public          postgres    false    215            �            1259    16406 	   engineers    TABLE     �  CREATE TABLE public.engineers (
    engineerid integer NOT NULL,
    lastname character varying(30),
    firstname character varying(30),
    middlename character varying(30),
    birthdate date,
    passportseries character(5),
    passportnumber character(6),
    passportissuedate date,
    passportissuingauthority character varying(100),
    mobilephone character(11),
    email character varying(255),
    city character varying(50),
    district character varying(50),
    street character varying(50),
    house character varying(4),
    apartment character varying(5),
    photo character varying(255),
    qualification integer NOT NULL
);
    DROP TABLE public.engineers;
       public         heap    postgres    false            �            1259    16405    engineers_engineerid_seq    SEQUENCE     �   CREATE SEQUENCE public.engineers_engineerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.engineers_engineerid_seq;
       public          postgres    false    218            �           0    0    engineers_engineerid_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.engineers_engineerid_seq OWNED BY public.engineers.engineerid;
          public          postgres    false    217            �            1259    16533    engineers_qualification_seq    SEQUENCE     �   CREATE SEQUENCE public.engineers_qualification_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.engineers_qualification_seq;
       public          postgres    false    218            �           0    0    engineers_qualification_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.engineers_qualification_seq OWNED BY public.engineers.qualification;
          public          postgres    false    229            �            1259    16469 	   equipment    TABLE     A  CREATE TABLE public.equipment (
    equipmentid integer NOT NULL,
    serialnumber character varying(100),
    brand character varying(30),
    model character varying(50),
    warrantyenddate date,
    photobeforerepair character varying(255),
    photoafterrepair character varying(255),
    equipment_catid integer
);
    DROP TABLE public.equipment;
       public         heap    postgres    false            �            1259    16547    equipment_categories    TABLE     �   CREATE TABLE public.equipment_categories (
    equipment_catid integer NOT NULL,
    equipment_catname character varying(20)
);
 (   DROP TABLE public.equipment_categories;
       public         heap    postgres    false            �            1259    16546 (   equipment_categories_equipment_catid_seq    SEQUENCE     �   CREATE SEQUENCE public.equipment_categories_equipment_catid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.equipment_categories_equipment_catid_seq;
       public          postgres    false    231            �           0    0 (   equipment_categories_equipment_catid_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.equipment_categories_equipment_catid_seq OWNED BY public.equipment_categories.equipment_catid;
          public          postgres    false    230            �            1259    16553    equipment_category_seq    SEQUENCE     �   CREATE SEQUENCE public.equipment_category_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.equipment_category_seq;
       public          postgres    false    222            �           0    0    equipment_category_seq    SEQUENCE OWNED BY     X   ALTER SEQUENCE public.equipment_category_seq OWNED BY public.equipment.equipment_catid;
          public          postgres    false    232            �            1259    16468    equipment_equipmentid_seq    SEQUENCE     �   CREATE SEQUENCE public.equipment_equipmentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.equipment_equipmentid_seq;
       public          postgres    false    222            �           0    0    equipment_equipmentid_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.equipment_equipmentid_seq OWNED BY public.equipment.equipmentid;
          public          postgres    false    221            �            1259    16460 	   operators    TABLE     f  CREATE TABLE public.operators (
    operatorid integer NOT NULL,
    lastname character varying(30),
    firstname character varying(30),
    middlename character varying(30),
    birthdate date,
    passportseries character(5),
    passportnumber character(6),
    passportissuedate date,
    passportissuingauthority character varying(100),
    mobilephone character(11),
    email character varying(255),
    city character varying(50),
    district character varying(50),
    street character varying(50),
    house character varying(4),
    apartment character varying(5),
    photo character varying(255)
);
    DROP TABLE public.operators;
       public         heap    postgres    false            �            1259    16459    operators_operatorid_seq    SEQUENCE     �   CREATE SEQUENCE public.operators_operatorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.operators_operatorid_seq;
       public          postgres    false    220            �           0    0    operators_operatorid_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.operators_operatorid_seq OWNED BY public.operators.operatorid;
          public          postgres    false    219            �            1259    16495    orders    TABLE     f  CREATE TABLE public.orders (
    orderid integer NOT NULL,
    clientid integer,
    operatorid integer,
    equipmentid integer,
    creationdate date,
    workstartdate date,
    workenddate date,
    underwarranty boolean,
    partscost numeric,
    laborcost numeric,
    totalcost numeric,
    status character varying(20),
    ord_status_id integer
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    16672    orders_engineers    TABLE     �   CREATE TABLE public.orders_engineers (
    oeid integer NOT NULL,
    orderid integer,
    engineerid integer,
    userid integer
);
 $   DROP TABLE public.orders_engineers;
       public         heap    postgres    false            �            1259    16671    orders_engineers_oeid_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_engineers_oeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.orders_engineers_oeid_seq;
       public          postgres    false    238            �           0    0    orders_engineers_oeid_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.orders_engineers_oeid_seq OWNED BY public.orders_engineers.oeid;
          public          postgres    false    237            �            1259    16689    orders_inspections    TABLE     |   CREATE TABLE public.orders_inspections (
    oiid integer NOT NULL,
    orderid integer,
    primaryinspectionid integer
);
 &   DROP TABLE public.orders_inspections;
       public         heap    postgres    false            �            1259    16688    orders_inspections_oiid_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_inspections_oiid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.orders_inspections_oiid_seq;
       public          postgres    false    240            �           0    0    orders_inspections_oiid_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.orders_inspections_oiid_seq OWNED BY public.orders_inspections.oiid;
          public          postgres    false    239            �            1259    16494    orders_orderid_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.orders_orderid_seq;
       public          postgres    false    226            �           0    0    orders_orderid_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;
          public          postgres    false    225            �            1259    16568    orders_status    TABLE     q   CREATE TABLE public.orders_status (
    ord_status_id integer NOT NULL,
    status_name character varying(20)
);
 !   DROP TABLE public.orders_status;
       public         heap    postgres    false            �            1259    16567    orders_status_ord_status_id_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_status_ord_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.orders_status_ord_status_id_seq;
       public          postgres    false    234            �           0    0    orders_status_ord_status_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.orders_status_ord_status_id_seq OWNED BY public.orders_status.ord_status_id;
          public          postgres    false    233            �            1259    16478    primaryinspections    TABLE     �   CREATE TABLE public.primaryinspections (
    primaryinspectionid integer NOT NULL,
    operatorid integer,
    equipmentid integer,
    result character varying(255)
);
 &   DROP TABLE public.primaryinspections;
       public         heap    postgres    false            �            1259    16477 *   primaryinspections_primaryinspectionid_seq    SEQUENCE     �   CREATE SEQUENCE public.primaryinspections_primaryinspectionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE public.primaryinspections_primaryinspectionid_seq;
       public          postgres    false    224            �           0    0 *   primaryinspections_primaryinspectionid_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public.primaryinspections_primaryinspectionid_seq OWNED BY public.primaryinspections.primaryinspectionid;
          public          postgres    false    223            �            1259    16527    qualifications    TABLE     {   CREATE TABLE public.qualifications (
    qualiid integer NOT NULL,
    qualificationname character varying(30) NOT NULL
);
 "   DROP TABLE public.qualifications;
       public         heap    postgres    false            �            1259    16526    qualifications_qualiid_seq    SEQUENCE     �   CREATE SEQUENCE public.qualifications_qualiid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.qualifications_qualiid_seq;
       public          postgres    false    228            �           0    0    qualifications_qualiid_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.qualifications_qualiid_seq OWNED BY public.qualifications.qualiid;
          public          postgres    false    227            �            1259    16706    roles    TABLE     �   CREATE TABLE public.roles (
    roleid integer NOT NULL,
    rolename character varying(20) NOT NULL,
    roleslug character varying(20) NOT NULL
);
    DROP TABLE public.roles;
       public         heap    postgres    false            �            1259    16705    roles_roleid_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_roleid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.roles_roleid_seq;
       public          postgres    false    242            �           0    0    roles_roleid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.roles_roleid_seq OWNED BY public.roles.roleid;
          public          postgres    false    241            �            1259    16582    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(128) NOT NULL,
    password character varying(255) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16585    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    235            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    236            �            1259    16717    users_roles    TABLE     ^   CREATE TABLE public.users_roles (
    userid integer NOT NULL,
    roleid integer NOT NULL
);
    DROP TABLE public.users_roles;
       public         heap    postgres    false            �           2604    16586    clients clientid    DEFAULT     t   ALTER TABLE ONLY public.clients ALTER COLUMN clientid SET DEFAULT nextval('public.clients_clientid_seq'::regclass);
 ?   ALTER TABLE public.clients ALTER COLUMN clientid DROP DEFAULT;
       public          postgres    false    215    216    216            �           2604    16587    engineers engineerid    DEFAULT     |   ALTER TABLE ONLY public.engineers ALTER COLUMN engineerid SET DEFAULT nextval('public.engineers_engineerid_seq'::regclass);
 C   ALTER TABLE public.engineers ALTER COLUMN engineerid DROP DEFAULT;
       public          postgres    false    218    217    218            �           2604    16588    engineers qualification    DEFAULT     �   ALTER TABLE ONLY public.engineers ALTER COLUMN qualification SET DEFAULT nextval('public.engineers_qualification_seq'::regclass);
 F   ALTER TABLE public.engineers ALTER COLUMN qualification DROP DEFAULT;
       public          postgres    false    229    218            �           2604    16589    equipment equipmentid    DEFAULT     ~   ALTER TABLE ONLY public.equipment ALTER COLUMN equipmentid SET DEFAULT nextval('public.equipment_equipmentid_seq'::regclass);
 D   ALTER TABLE public.equipment ALTER COLUMN equipmentid DROP DEFAULT;
       public          postgres    false    222    221    222            �           2604    16590    equipment equipment_catid    DEFAULT        ALTER TABLE ONLY public.equipment ALTER COLUMN equipment_catid SET DEFAULT nextval('public.equipment_category_seq'::regclass);
 H   ALTER TABLE public.equipment ALTER COLUMN equipment_catid DROP DEFAULT;
       public          postgres    false    232    222            �           2604    16591 $   equipment_categories equipment_catid    DEFAULT     �   ALTER TABLE ONLY public.equipment_categories ALTER COLUMN equipment_catid SET DEFAULT nextval('public.equipment_categories_equipment_catid_seq'::regclass);
 S   ALTER TABLE public.equipment_categories ALTER COLUMN equipment_catid DROP DEFAULT;
       public          postgres    false    231    230    231            �           2604    16592    operators operatorid    DEFAULT     |   ALTER TABLE ONLY public.operators ALTER COLUMN operatorid SET DEFAULT nextval('public.operators_operatorid_seq'::regclass);
 C   ALTER TABLE public.operators ALTER COLUMN operatorid DROP DEFAULT;
       public          postgres    false    219    220    220            �           2604    16593    orders orderid    DEFAULT     p   ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);
 =   ALTER TABLE public.orders ALTER COLUMN orderid DROP DEFAULT;
       public          postgres    false    226    225    226            �           2604    16675    orders_engineers oeid    DEFAULT     ~   ALTER TABLE ONLY public.orders_engineers ALTER COLUMN oeid SET DEFAULT nextval('public.orders_engineers_oeid_seq'::regclass);
 D   ALTER TABLE public.orders_engineers ALTER COLUMN oeid DROP DEFAULT;
       public          postgres    false    237    238    238            �           2604    16692    orders_inspections oiid    DEFAULT     �   ALTER TABLE ONLY public.orders_inspections ALTER COLUMN oiid SET DEFAULT nextval('public.orders_inspections_oiid_seq'::regclass);
 F   ALTER TABLE public.orders_inspections ALTER COLUMN oiid DROP DEFAULT;
       public          postgres    false    240    239    240            �           2604    16594    orders_status ord_status_id    DEFAULT     �   ALTER TABLE ONLY public.orders_status ALTER COLUMN ord_status_id SET DEFAULT nextval('public.orders_status_ord_status_id_seq'::regclass);
 J   ALTER TABLE public.orders_status ALTER COLUMN ord_status_id DROP DEFAULT;
       public          postgres    false    233    234    234            �           2604    16595 &   primaryinspections primaryinspectionid    DEFAULT     �   ALTER TABLE ONLY public.primaryinspections ALTER COLUMN primaryinspectionid SET DEFAULT nextval('public.primaryinspections_primaryinspectionid_seq'::regclass);
 U   ALTER TABLE public.primaryinspections ALTER COLUMN primaryinspectionid DROP DEFAULT;
       public          postgres    false    223    224    224            �           2604    16596    qualifications qualiid    DEFAULT     �   ALTER TABLE ONLY public.qualifications ALTER COLUMN qualiid SET DEFAULT nextval('public.qualifications_qualiid_seq'::regclass);
 E   ALTER TABLE public.qualifications ALTER COLUMN qualiid DROP DEFAULT;
       public          postgres    false    227    228    228            �           2604    16709    roles roleid    DEFAULT     l   ALTER TABLE ONLY public.roles ALTER COLUMN roleid SET DEFAULT nextval('public.roles_roleid_seq'::regclass);
 ;   ALTER TABLE public.roles ALTER COLUMN roleid DROP DEFAULT;
       public          postgres    false    241    242    242            �           2604    16597    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            a          0    16399    clients 
   TABLE DATA           `   COPY public.clients (clientid, lastname, firstname, middlename, mobilephone, email) FROM stdin;
    public          postgres    false    216   ��       c          0    16406 	   engineers 
   TABLE DATA           �   COPY public.engineers (engineerid, lastname, firstname, middlename, birthdate, passportseries, passportnumber, passportissuedate, passportissuingauthority, mobilephone, email, city, district, street, house, apartment, photo, qualification) FROM stdin;
    public          postgres    false    218   ��       g          0    16469 	   equipment 
   TABLE DATA           �   COPY public.equipment (equipmentid, serialnumber, brand, model, warrantyenddate, photobeforerepair, photoafterrepair, equipment_catid) FROM stdin;
    public          postgres    false    222   3�       p          0    16547    equipment_categories 
   TABLE DATA           R   COPY public.equipment_categories (equipment_catid, equipment_catname) FROM stdin;
    public          postgres    false    231   ��       e          0    16460 	   operators 
   TABLE DATA           �   COPY public.operators (operatorid, lastname, firstname, middlename, birthdate, passportseries, passportnumber, passportissuedate, passportissuingauthority, mobilephone, email, city, district, street, house, apartment, photo) FROM stdin;
    public          postgres    false    220   ߥ       k          0    16495    orders 
   TABLE DATA           �   COPY public.orders (orderid, clientid, operatorid, equipmentid, creationdate, workstartdate, workenddate, underwarranty, partscost, laborcost, totalcost, status, ord_status_id) FROM stdin;
    public          postgres    false    226   	�       w          0    16672    orders_engineers 
   TABLE DATA           M   COPY public.orders_engineers (oeid, orderid, engineerid, userid) FROM stdin;
    public          postgres    false    238   8�       y          0    16689    orders_inspections 
   TABLE DATA           P   COPY public.orders_inspections (oiid, orderid, primaryinspectionid) FROM stdin;
    public          postgres    false    240   s�       s          0    16568    orders_status 
   TABLE DATA           C   COPY public.orders_status (ord_status_id, status_name) FROM stdin;
    public          postgres    false    234   ��       i          0    16478    primaryinspections 
   TABLE DATA           b   COPY public.primaryinspections (primaryinspectionid, operatorid, equipmentid, result) FROM stdin;
    public          postgres    false    224   �       m          0    16527    qualifications 
   TABLE DATA           D   COPY public.qualifications (qualiid, qualificationname) FROM stdin;
    public          postgres    false    228   M�       {          0    16706    roles 
   TABLE DATA           ;   COPY public.roles (roleid, rolename, roleslug) FROM stdin;
    public          postgres    false    242   ��       t          0    16582    users 
   TABLE DATA           4   COPY public.users (id, login, password) FROM stdin;
    public          postgres    false    235   �       |          0    16717    users_roles 
   TABLE DATA           5   COPY public.users_roles (userid, roleid) FROM stdin;
    public          postgres    false    243   t�       �           0    0    clients_clientid_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.clients_clientid_seq', 12, true);
          public          postgres    false    215            �           0    0    engineers_engineerid_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.engineers_engineerid_seq', 3, true);
          public          postgres    false    217            �           0    0    engineers_qualification_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.engineers_qualification_seq', 1, false);
          public          postgres    false    229            �           0    0 (   equipment_categories_equipment_catid_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.equipment_categories_equipment_catid_seq', 2, true);
          public          postgres    false    230            �           0    0    equipment_category_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.equipment_category_seq', 2, true);
          public          postgres    false    232            �           0    0    equipment_equipmentid_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.equipment_equipmentid_seq', 11, true);
          public          postgres    false    221            �           0    0    operators_operatorid_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.operators_operatorid_seq', 2, true);
          public          postgres    false    219            �           0    0    orders_engineers_oeid_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.orders_engineers_oeid_seq', 6, true);
          public          postgres    false    237            �           0    0    orders_inspections_oiid_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.orders_inspections_oiid_seq', 7, true);
          public          postgres    false    239            �           0    0    orders_orderid_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.orders_orderid_seq', 23, true);
          public          postgres    false    225            �           0    0    orders_status_ord_status_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.orders_status_ord_status_id_seq', 4, true);
          public          postgres    false    233            �           0    0 *   primaryinspections_primaryinspectionid_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public.primaryinspections_primaryinspectionid_seq', 15, true);
          public          postgres    false    223            �           0    0    qualifications_qualiid_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.qualifications_qualiid_seq', 3, true);
          public          postgres    false    227            �           0    0    roles_roleid_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.roles_roleid_seq', 3, true);
          public          postgres    false    241            �           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 6, true);
          public          postgres    false    236            �           2606    16404    clients clients_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (clientid);
 >   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
       public            postgres    false    216            �           2606    16413    engineers engineers_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT engineers_pkey PRIMARY KEY (engineerid);
 B   ALTER TABLE ONLY public.engineers DROP CONSTRAINT engineers_pkey;
       public            postgres    false    218            �           2606    16552 .   equipment_categories equipment_categories_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.equipment_categories
    ADD CONSTRAINT equipment_categories_pkey PRIMARY KEY (equipment_catid);
 X   ALTER TABLE ONLY public.equipment_categories DROP CONSTRAINT equipment_categories_pkey;
       public            postgres    false    231            �           2606    16476    equipment equipment_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (equipmentid);
 B   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_pkey;
       public            postgres    false    222            �           2606    16467    operators operators_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.operators
    ADD CONSTRAINT operators_pkey PRIMARY KEY (operatorid);
 B   ALTER TABLE ONLY public.operators DROP CONSTRAINT operators_pkey;
       public            postgres    false    220            �           2606    16677 &   orders_engineers orders_engineers_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.orders_engineers
    ADD CONSTRAINT orders_engineers_pkey PRIMARY KEY (oeid);
 P   ALTER TABLE ONLY public.orders_engineers DROP CONSTRAINT orders_engineers_pkey;
       public            postgres    false    238            �           2606    16694 *   orders_inspections orders_inspections_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.orders_inspections
    ADD CONSTRAINT orders_inspections_pkey PRIMARY KEY (oiid);
 T   ALTER TABLE ONLY public.orders_inspections DROP CONSTRAINT orders_inspections_pkey;
       public            postgres    false    240            �           2606    16500    orders orders_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    226            �           2606    16573     orders_status orders_status_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.orders_status
    ADD CONSTRAINT orders_status_pkey PRIMARY KEY (ord_status_id);
 J   ALTER TABLE ONLY public.orders_status DROP CONSTRAINT orders_status_pkey;
       public            postgres    false    234            �           2606    16483 *   primaryinspections primaryinspections_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.primaryinspections
    ADD CONSTRAINT primaryinspections_pkey PRIMARY KEY (primaryinspectionid);
 T   ALTER TABLE ONLY public.primaryinspections DROP CONSTRAINT primaryinspections_pkey;
       public            postgres    false    224            �           2606    16532 "   qualifications qualifications_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.qualifications
    ADD CONSTRAINT qualifications_pkey PRIMARY KEY (qualiid);
 L   ALTER TABLE ONLY public.qualifications DROP CONSTRAINT qualifications_pkey;
       public            postgres    false    228            �           2606    16711    roles roles_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (roleid);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    242            �           2606    16599    users users_login_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_login_key;
       public            postgres    false    235            �           2606    16601    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    235            �           2606    16721    users_roles users_roles_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles_pkey PRIMARY KEY (userid, roleid);
 F   ALTER TABLE ONLY public.users_roles DROP CONSTRAINT users_roles_pkey;
       public            postgres    false    243    243            �           2606    16541 %   engineers fk_engineers_qualifications    FK CONSTRAINT     �   ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT fk_engineers_qualifications FOREIGN KEY (qualification) REFERENCES public.qualifications(qualiid);
 O   ALTER TABLE ONLY public.engineers DROP CONSTRAINT fk_engineers_qualifications;
       public          postgres    false    4785    228    218            �           2606    16562    equipment fk_equipment_category    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT fk_equipment_category FOREIGN KEY (equipment_catid) REFERENCES public.equipment_categories(equipment_catid);
 I   ALTER TABLE ONLY public.equipment DROP CONSTRAINT fk_equipment_category;
       public          postgres    false    4787    231    222            �           2606    16574    orders ord_status_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT ord_status_id_fkey FOREIGN KEY (ord_status_id) REFERENCES public.orders_status(ord_status_id);
 C   ALTER TABLE ONLY public.orders DROP CONSTRAINT ord_status_id_fkey;
       public          postgres    false    4789    234    226            �           2606    16501    orders orders_clientid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_clientid_fkey FOREIGN KEY (clientid) REFERENCES public.clients(clientid);
 E   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_clientid_fkey;
       public          postgres    false    226    4773    216            �           2606    16683 1   orders_engineers orders_engineers_engineedir_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders_engineers
    ADD CONSTRAINT orders_engineers_engineedir_fkey FOREIGN KEY (engineerid) REFERENCES public.engineers(engineerid);
 [   ALTER TABLE ONLY public.orders_engineers DROP CONSTRAINT orders_engineers_engineedir_fkey;
       public          postgres    false    238    218    4775            �           2606    16678 .   orders_engineers orders_engineers_orderid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders_engineers
    ADD CONSTRAINT orders_engineers_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orders(orderid);
 X   ALTER TABLE ONLY public.orders_engineers DROP CONSTRAINT orders_engineers_orderid_fkey;
       public          postgres    false    238    4783    226            �           2606    16777 -   orders_engineers orders_engineers_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders_engineers
    ADD CONSTRAINT orders_engineers_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);
 W   ALTER TABLE ONLY public.orders_engineers DROP CONSTRAINT orders_engineers_userid_fkey;
       public          postgres    false    235    4793    238            �           2606    16516    orders orders_equipmentid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_equipmentid_fkey FOREIGN KEY (equipmentid) REFERENCES public.equipment(equipmentid);
 H   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_equipmentid_fkey;
       public          postgres    false    4779    222    226            �           2606    16695 2   orders_inspections orders_inspections_orderid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders_inspections
    ADD CONSTRAINT orders_inspections_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orders(orderid);
 \   ALTER TABLE ONLY public.orders_inspections DROP CONSTRAINT orders_inspections_orderid_fkey;
       public          postgres    false    4783    240    226            �           2606    16700 >   orders_inspections orders_inspections_primaryinspectionid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders_inspections
    ADD CONSTRAINT orders_inspections_primaryinspectionid_fkey FOREIGN KEY (primaryinspectionid) REFERENCES public.primaryinspections(primaryinspectionid);
 h   ALTER TABLE ONLY public.orders_inspections DROP CONSTRAINT orders_inspections_primaryinspectionid_fkey;
       public          postgres    false    4781    240    224            �           2606    16506    orders orders_operatorid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_operatorid_fkey FOREIGN KEY (operatorid) REFERENCES public.operators(operatorid);
 G   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_operatorid_fkey;
       public          postgres    false    4777    220    226            �           2606    16489 6   primaryinspections primaryinspections_equipmentid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.primaryinspections
    ADD CONSTRAINT primaryinspections_equipmentid_fkey FOREIGN KEY (equipmentid) REFERENCES public.equipment(equipmentid);
 `   ALTER TABLE ONLY public.primaryinspections DROP CONSTRAINT primaryinspections_equipmentid_fkey;
       public          postgres    false    4779    224    222            �           2606    16484 5   primaryinspections primaryinspections_operatorid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.primaryinspections
    ADD CONSTRAINT primaryinspections_operatorid_fkey FOREIGN KEY (operatorid) REFERENCES public.operators(operatorid);
 _   ALTER TABLE ONLY public.primaryinspections DROP CONSTRAINT primaryinspections_operatorid_fkey;
       public          postgres    false    224    4777    220            �           2606    16727 #   users_roles users_roles_roleid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles_roleid_fkey FOREIGN KEY (roleid) REFERENCES public.roles(roleid);
 M   ALTER TABLE ONLY public.users_roles DROP CONSTRAINT users_roles_roleid_fkey;
       public          postgres    false    243    242    4799            �           2606    16722 #   users_roles users_roles_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id);
 M   ALTER TABLE ONLY public.users_roles DROP CONSTRAINT users_roles_userid_fkey;
       public          postgres    false    243    235    4793            a   �   x�]�1
�@�z�9��n���x�E.��D�jc��� � ��D�3���#Bl~����	7�(Q��4P/C!��~���T��d�h��|�Qb�$\�;�i����w<�G˔����x⎪���]x�C[�zdT�_�q�Ղ�f���J�/<P��緻;�QR8�Q~}�h2�q�(=��9c�L�v|      c   �  x����J�@��'O��t�IƕO��Ik�Ѵ)Z���Vԅ��A�.�7���W8y�ē�P��.f`&�w�/� <�	>�z`�/8��i��'��{tx�Q~���|O�
���B��3�1�o�>Ӌ�����!�pT�<���[k�Jia�����v�����N"��6�i�"d8��Y~�+��y??�1��qX��?�!���鴗��)Pu�o�Ү��^�H��B��N /JUb�{P��a�a\32�=I�J�
Mɸe���4���Rkc J�V��q�&�"��e���h5Kt3�M�nX�JGB��d���9��G�FE���\6;�-gB0�IZ��|��BZ3����RZ)e���Z��v��iś��{F�'����&fx���_嬺��|�^X      g   =  x�e��n�0�����t��ҟ˖�-Z�7�ZZנ�����
&�$Vr>��Q<D�
	J�7�zc]�o�H	r�mWٱ�D�D����G&�60ӛ�Kl�G��D�!��e�|��i"h2�vU	۹.�����$sA%�r���A(���2�~����-1�<SI�F!L��|x���z2�i2ʓyH���.��m�$�C`���U��<w�|^�.9:�X*�fk�us�*���f�G-�.֒H�+�������^G@:H@�tS�:�x2
��l_�e�?�2�����B�fY]1�~ ���U      p   O   x�ɹ�0E�x�$�r(�@�!'�]�����UQ�S��;��%iR�L�xo�<$�������?�ظ�b�*(      e     x����J�@�ϓ��l���&YO>�O�K�P��	����=
�}Cm!��0�F�j�z/��,�7�-=ВZ蝖@�\����hAk;��Pg���Bj���:I3#AI�~*�z�3Zq��郃=���ΧgG���j���;H�1��T�q���(���<�V�"8,������#��;P���fL��h8��j/�0�798�ƞ�)���K/����f�,�B)��`�4ѱSF!��(+'�PN�yP�Y��q^ع���]k���ް��G��y����6      k     x��S�m�0=SSt�>��D&ȹx� �
d��� -�K2�Q)%���uX ��'���Q����X`�k���Bw-dm���?���|�heA�gʤ/0� 5��h�R�[�m�)�Q�BH00��9(m��EU�r�"�DB5�`�~\|�������e{IG28x���:��}\�m&.
YF,2�32���@0��!d�1֕�oBz�_��;�����j&����&��mȒ^|�Wg��u�C��t�ǖ�g
,�d�}�EO��+�s�5��d��/���Lj�RJ�3��O      w   +   x�3�42�4�4�2�4�2�L9�8��"f���`�=... pHA      y   3   x�ȱ�0����~h�����&B,�z��MO֡7Y>پt���ΎW      s   M   x�3估�®���_l���b��F.#�s.l�����\Ɯ�d.l���b?P���¬��/쿰�"F��� ��(�      i   *  x��Q;N�P���x�'Z
�@C�D$�4�O���U�.�D�b�ľ�썘������+V����y>�|�#s:F�%*�3��������Úa�1RH����A�T�(��]�.�������[	�,Vd+�E,�ң�^��3��~7vH�a���((2Q,��'i?���D�\'�Q�!��@t�k}d����vÖ��m[��+�Jg�E���r֘�`J�䜉���lVVAER&9��S�w��0�&�O���$����?���#myćmq�W���:~0d���~��>�/�xM�      m   Z   x�m�;�0E�>U@�AL?,x �P �X����z>���Lπ���B�8Q�,�8�Q����Q�9��:=ao����a�����D�      {   :   x�3�tL����,.)J,�/�L�8�R!�@�1�k^zf^jjg*������ lo=      t   c  x�e�Ak@�ϻ�c�2�L2��j)
*T�Li�ݖUY�����S!�@x/�{�9����ߟ�_�ty�}���\���oG����|s�3��Xs���Z,"��9!1e�j�a�Q��R�[�
��X�N���J� �L�N�(Q�J��V��u�b��rt"n9eK�a�%��/��<�>^��~�t�L�Z���Ж���"ﮨ�O�;� �>��9��p�����ʘ����Yh�8���	#P���%j\Ej�2�9ly�wǈ�Kڷ_�?>_n`|:~��HF�j+h��Ե�gw�f�}�⡷��(�MZHŭ��c`>z�U��+��X�+Gj�R!���X��V�.����j���$ݕQ      |      x�3�4�2b3Nc�=... x     