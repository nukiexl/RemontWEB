PGDMP                  
    {            remont    16.1    16.1 `               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                        0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            !           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            "           1262    16398    remont    DATABASE     z   CREATE DATABASE remont WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE remont;
                postgres    false            �            1255    16458 "   get_category_id(character varying)    FUNCTION     .  CREATE FUNCTION public.get_category_id(category_name character varying) RETURNS integer
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
       public          postgres    false            �            1255    16459 g   insert_into_equipment(character varying, character varying, character varying, date, character varying)    FUNCTION     �  CREATE FUNCTION public.insert_into_equipment(serialnumber character varying, brand character varying, model character varying, acceptancedate date, category_name character varying) RETURNS void
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
       public          postgres    false            �            1255    16460    update_total_cost(integer)    FUNCTION     �   CREATE FUNCTION public.update_total_cost(order_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
        UPDATE orders
        SET totalcost = (partscost + laborcost) * 1.2
        WHERE orderid = order_id;
END;
$$;
 :   DROP FUNCTION public.update_total_cost(order_id integer);
       public          postgres    false            �            1259    16461    clients    TABLE     �   CREATE TABLE public.clients (
    clientid integer NOT NULL,
    lastname character varying(30),
    firstname character varying(30),
    middlename character varying(30),
    mobilephone character(12),
    email character varying(255)
);
    DROP TABLE public.clients;
       public         heap    postgres    false            �            1259    16464    clients_clientid_seq    SEQUENCE     �   CREATE SEQUENCE public.clients_clientid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.clients_clientid_seq;
       public          postgres    false    215            #           0    0    clients_clientid_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.clients_clientid_seq OWNED BY public.clients.clientid;
          public          postgres    false    216            �            1259    16465 	   engineers    TABLE     �  CREATE TABLE public.engineers (
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
       public         heap    postgres    false            �            1259    16470    engineers_engineerid_seq    SEQUENCE     �   CREATE SEQUENCE public.engineers_engineerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.engineers_engineerid_seq;
       public          postgres    false    217            $           0    0    engineers_engineerid_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.engineers_engineerid_seq OWNED BY public.engineers.engineerid;
          public          postgres    false    218            �            1259    16471    engineers_qualification_seq    SEQUENCE     �   CREATE SEQUENCE public.engineers_qualification_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.engineers_qualification_seq;
       public          postgres    false    217            %           0    0    engineers_qualification_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.engineers_qualification_seq OWNED BY public.engineers.qualification;
          public          postgres    false    219            �            1259    16472 	   equipment    TABLE     p  CREATE TABLE public.equipment (
    equipmentid integer NOT NULL,
    serialnumber character varying(100),
    brand character varying(30),
    model character varying(50),
    acceptancedate date,
    issuedate date,
    warrantyenddate date,
    photobeforerepair character varying(255),
    photoafterrepair character varying(255),
    category integer NOT NULL
);
    DROP TABLE public.equipment;
       public         heap    postgres    false            �            1259    16477    equipment_categories    TABLE     �   CREATE TABLE public.equipment_categories (
    equipment_catid integer NOT NULL,
    equipment_catname character varying(20)
);
 (   DROP TABLE public.equipment_categories;
       public         heap    postgres    false            �            1259    16480 (   equipment_categories_equipment_catid_seq    SEQUENCE     �   CREATE SEQUENCE public.equipment_categories_equipment_catid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.equipment_categories_equipment_catid_seq;
       public          postgres    false    221            &           0    0 (   equipment_categories_equipment_catid_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.equipment_categories_equipment_catid_seq OWNED BY public.equipment_categories.equipment_catid;
          public          postgres    false    222            �            1259    16481    equipment_category_seq    SEQUENCE     �   CREATE SEQUENCE public.equipment_category_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.equipment_category_seq;
       public          postgres    false    220            '           0    0    equipment_category_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.equipment_category_seq OWNED BY public.equipment.category;
          public          postgres    false    223            �            1259    16482    equipment_equipmentid_seq    SEQUENCE     �   CREATE SEQUENCE public.equipment_equipmentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.equipment_equipmentid_seq;
       public          postgres    false    220            (           0    0    equipment_equipmentid_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.equipment_equipmentid_seq OWNED BY public.equipment.equipmentid;
          public          postgres    false    224            �            1259    16483 	   operators    TABLE     f  CREATE TABLE public.operators (
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
       public         heap    postgres    false            �            1259    16488    operators_operatorid_seq    SEQUENCE     �   CREATE SEQUENCE public.operators_operatorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.operators_operatorid_seq;
       public          postgres    false    225            )           0    0    operators_operatorid_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.operators_operatorid_seq OWNED BY public.operators.operatorid;
          public          postgres    false    226            �            1259    16489    orders    TABLE     �  CREATE TABLE public.orders (
    orderid integer NOT NULL,
    clientid integer,
    operatorid integer,
    engineerid integer,
    equipmentid integer,
    primaryinspectionid integer,
    creationdate date,
    workstartdate date,
    workenddate date,
    underwarranty boolean,
    partscost money,
    laborcost money,
    totalcost money,
    status character varying(20),
    ord_status_id integer
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    16492    orders_orderid_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.orders_orderid_seq;
       public          postgres    false    227            *           0    0    orders_orderid_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;
          public          postgres    false    228            �            1259    16493    orders_status    TABLE     q   CREATE TABLE public.orders_status (
    ord_status_id integer NOT NULL,
    status_name character varying(20)
);
 !   DROP TABLE public.orders_status;
       public         heap    postgres    false            �            1259    16496    orders_status_ord_status_id_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_status_ord_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.orders_status_ord_status_id_seq;
       public          postgres    false    229            +           0    0    orders_status_ord_status_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.orders_status_ord_status_id_seq OWNED BY public.orders_status.ord_status_id;
          public          postgres    false    230            �            1259    16497    primaryinspections    TABLE     �   CREATE TABLE public.primaryinspections (
    primaryinspectionid integer NOT NULL,
    operatorid integer,
    equipmentid integer,
    result character varying(255)
);
 &   DROP TABLE public.primaryinspections;
       public         heap    postgres    false            �            1259    16500 *   primaryinspections_primaryinspectionid_seq    SEQUENCE     �   CREATE SEQUENCE public.primaryinspections_primaryinspectionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE public.primaryinspections_primaryinspectionid_seq;
       public          postgres    false    231            ,           0    0 *   primaryinspections_primaryinspectionid_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public.primaryinspections_primaryinspectionid_seq OWNED BY public.primaryinspections.primaryinspectionid;
          public          postgres    false    232            �            1259    16501    qualifications    TABLE     {   CREATE TABLE public.qualifications (
    qualiid integer NOT NULL,
    qualificationname character varying(30) NOT NULL
);
 "   DROP TABLE public.qualifications;
       public         heap    postgres    false            �            1259    16504    qualifications_qualiid_seq    SEQUENCE     �   CREATE SEQUENCE public.qualifications_qualiid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.qualifications_qualiid_seq;
       public          postgres    false    233            -           0    0    qualifications_qualiid_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.qualifications_qualiid_seq OWNED BY public.qualifications.qualiid;
          public          postgres    false    234            �            1259    16585    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(128) NOT NULL,
    password character varying(255) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16584    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    236            .           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    235            L           2604    16505    clients clientid    DEFAULT     t   ALTER TABLE ONLY public.clients ALTER COLUMN clientid SET DEFAULT nextval('public.clients_clientid_seq'::regclass);
 ?   ALTER TABLE public.clients ALTER COLUMN clientid DROP DEFAULT;
       public          postgres    false    216    215            M           2604    16506    engineers engineerid    DEFAULT     |   ALTER TABLE ONLY public.engineers ALTER COLUMN engineerid SET DEFAULT nextval('public.engineers_engineerid_seq'::regclass);
 C   ALTER TABLE public.engineers ALTER COLUMN engineerid DROP DEFAULT;
       public          postgres    false    218    217            N           2604    16507    engineers qualification    DEFAULT     �   ALTER TABLE ONLY public.engineers ALTER COLUMN qualification SET DEFAULT nextval('public.engineers_qualification_seq'::regclass);
 F   ALTER TABLE public.engineers ALTER COLUMN qualification DROP DEFAULT;
       public          postgres    false    219    217            O           2604    16508    equipment equipmentid    DEFAULT     ~   ALTER TABLE ONLY public.equipment ALTER COLUMN equipmentid SET DEFAULT nextval('public.equipment_equipmentid_seq'::regclass);
 D   ALTER TABLE public.equipment ALTER COLUMN equipmentid DROP DEFAULT;
       public          postgres    false    224    220            P           2604    16509    equipment category    DEFAULT     x   ALTER TABLE ONLY public.equipment ALTER COLUMN category SET DEFAULT nextval('public.equipment_category_seq'::regclass);
 A   ALTER TABLE public.equipment ALTER COLUMN category DROP DEFAULT;
       public          postgres    false    223    220            Q           2604    16510 $   equipment_categories equipment_catid    DEFAULT     �   ALTER TABLE ONLY public.equipment_categories ALTER COLUMN equipment_catid SET DEFAULT nextval('public.equipment_categories_equipment_catid_seq'::regclass);
 S   ALTER TABLE public.equipment_categories ALTER COLUMN equipment_catid DROP DEFAULT;
       public          postgres    false    222    221            R           2604    16511    operators operatorid    DEFAULT     |   ALTER TABLE ONLY public.operators ALTER COLUMN operatorid SET DEFAULT nextval('public.operators_operatorid_seq'::regclass);
 C   ALTER TABLE public.operators ALTER COLUMN operatorid DROP DEFAULT;
       public          postgres    false    226    225            S           2604    16512    orders orderid    DEFAULT     p   ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);
 =   ALTER TABLE public.orders ALTER COLUMN orderid DROP DEFAULT;
       public          postgres    false    228    227            T           2604    16513    orders_status ord_status_id    DEFAULT     �   ALTER TABLE ONLY public.orders_status ALTER COLUMN ord_status_id SET DEFAULT nextval('public.orders_status_ord_status_id_seq'::regclass);
 J   ALTER TABLE public.orders_status ALTER COLUMN ord_status_id DROP DEFAULT;
       public          postgres    false    230    229            U           2604    16514 &   primaryinspections primaryinspectionid    DEFAULT     �   ALTER TABLE ONLY public.primaryinspections ALTER COLUMN primaryinspectionid SET DEFAULT nextval('public.primaryinspections_primaryinspectionid_seq'::regclass);
 U   ALTER TABLE public.primaryinspections ALTER COLUMN primaryinspectionid DROP DEFAULT;
       public          postgres    false    232    231            V           2604    16515    qualifications qualiid    DEFAULT     �   ALTER TABLE ONLY public.qualifications ALTER COLUMN qualiid SET DEFAULT nextval('public.qualifications_qualiid_seq'::regclass);
 E   ALTER TABLE public.qualifications ALTER COLUMN qualiid DROP DEFAULT;
       public          postgres    false    234    233            W           2604    16588    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235    236                      0    16461    clients 
   TABLE DATA           `   COPY public.clients (clientid, lastname, firstname, middlename, mobilephone, email) FROM stdin;
    public          postgres    false    215   ]~       	          0    16465 	   engineers 
   TABLE DATA           �   COPY public.engineers (engineerid, lastname, firstname, middlename, birthdate, passportseries, passportnumber, passportissuedate, passportissuingauthority, mobilephone, email, city, district, street, house, apartment, photo, qualification) FROM stdin;
    public          postgres    false    217   �                 0    16472 	   equipment 
   TABLE DATA           �   COPY public.equipment (equipmentid, serialnumber, brand, model, acceptancedate, issuedate, warrantyenddate, photobeforerepair, photoafterrepair, category) FROM stdin;
    public          postgres    false    220   _�                 0    16477    equipment_categories 
   TABLE DATA           R   COPY public.equipment_categories (equipment_catid, equipment_catname) FROM stdin;
    public          postgres    false    221   ^�                 0    16483 	   operators 
   TABLE DATA           �   COPY public.operators (operatorid, lastname, firstname, middlename, birthdate, passportseries, passportnumber, passportissuedate, passportissuingauthority, mobilephone, email, city, district, street, house, apartment, photo) FROM stdin;
    public          postgres    false    225   ��                 0    16489    orders 
   TABLE DATA           �   COPY public.orders (orderid, clientid, operatorid, engineerid, equipmentid, primaryinspectionid, creationdate, workstartdate, workenddate, underwarranty, partscost, laborcost, totalcost, status, ord_status_id) FROM stdin;
    public          postgres    false    227   �                 0    16493    orders_status 
   TABLE DATA           C   COPY public.orders_status (ord_status_id, status_name) FROM stdin;
    public          postgres    false    229   ʄ                 0    16497    primaryinspections 
   TABLE DATA           b   COPY public.primaryinspections (primaryinspectionid, operatorid, equipmentid, result) FROM stdin;
    public          postgres    false    231   '�                 0    16501    qualifications 
   TABLE DATA           D   COPY public.qualifications (qualiid, qualificationname) FROM stdin;
    public          postgres    false    233   �                 0    16585    users 
   TABLE DATA           4   COPY public.users (id, login, password) FROM stdin;
    public          postgres    false    236   x�       /           0    0    clients_clientid_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.clients_clientid_seq', 7, true);
          public          postgres    false    216            0           0    0    engineers_engineerid_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.engineers_engineerid_seq', 3, true);
          public          postgres    false    218            1           0    0    engineers_qualification_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.engineers_qualification_seq', 1, false);
          public          postgres    false    219            2           0    0 (   equipment_categories_equipment_catid_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.equipment_categories_equipment_catid_seq', 2, true);
          public          postgres    false    222            3           0    0    equipment_category_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.equipment_category_seq', 1, false);
          public          postgres    false    223            4           0    0    equipment_equipmentid_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.equipment_equipmentid_seq', 6, true);
          public          postgres    false    224            5           0    0    operators_operatorid_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.operators_operatorid_seq', 2, true);
          public          postgres    false    226            6           0    0    orders_orderid_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.orders_orderid_seq', 6, true);
          public          postgres    false    228            7           0    0    orders_status_ord_status_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.orders_status_ord_status_id_seq', 4, true);
          public          postgres    false    230            8           0    0 *   primaryinspections_primaryinspectionid_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('public.primaryinspections_primaryinspectionid_seq', 5, true);
          public          postgres    false    232            9           0    0    qualifications_qualiid_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.qualifications_qualiid_seq', 3, true);
          public          postgres    false    234            :           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 1, true);
          public          postgres    false    235            Y           2606    16517    clients clients_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (clientid);
 >   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
       public            postgres    false    215            [           2606    16519    engineers engineers_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT engineers_pkey PRIMARY KEY (engineerid);
 B   ALTER TABLE ONLY public.engineers DROP CONSTRAINT engineers_pkey;
       public            postgres    false    217            _           2606    16521 .   equipment_categories equipment_categories_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.equipment_categories
    ADD CONSTRAINT equipment_categories_pkey PRIMARY KEY (equipment_catid);
 X   ALTER TABLE ONLY public.equipment_categories DROP CONSTRAINT equipment_categories_pkey;
       public            postgres    false    221            ]           2606    16523    equipment equipment_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (equipmentid);
 B   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_pkey;
       public            postgres    false    220            a           2606    16525    operators operators_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.operators
    ADD CONSTRAINT operators_pkey PRIMARY KEY (operatorid);
 B   ALTER TABLE ONLY public.operators DROP CONSTRAINT operators_pkey;
       public            postgres    false    225            c           2606    16527    orders orders_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    227            e           2606    16529     orders_status orders_status_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.orders_status
    ADD CONSTRAINT orders_status_pkey PRIMARY KEY (ord_status_id);
 J   ALTER TABLE ONLY public.orders_status DROP CONSTRAINT orders_status_pkey;
       public            postgres    false    229            g           2606    16531 *   primaryinspections primaryinspections_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.primaryinspections
    ADD CONSTRAINT primaryinspections_pkey PRIMARY KEY (primaryinspectionid);
 T   ALTER TABLE ONLY public.primaryinspections DROP CONSTRAINT primaryinspections_pkey;
       public            postgres    false    231            i           2606    16533 "   qualifications qualifications_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.qualifications
    ADD CONSTRAINT qualifications_pkey PRIMARY KEY (qualiid);
 L   ALTER TABLE ONLY public.qualifications DROP CONSTRAINT qualifications_pkey;
       public            postgres    false    233            k           2606    16592    users users_login_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_login_key;
       public            postgres    false    236            m           2606    16590    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    236            n           2606    16534 %   engineers fk_engineers_qualifications    FK CONSTRAINT     �   ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT fk_engineers_qualifications FOREIGN KEY (qualification) REFERENCES public.qualifications(qualiid);
 O   ALTER TABLE ONLY public.engineers DROP CONSTRAINT fk_engineers_qualifications;
       public          postgres    false    217    4713    233            o           2606    16539    equipment fk_equipment_category    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT fk_equipment_category FOREIGN KEY (category) REFERENCES public.equipment_categories(equipment_catid);
 I   ALTER TABLE ONLY public.equipment DROP CONSTRAINT fk_equipment_category;
       public          postgres    false    221    220    4703            p           2606    16544    orders ord_status_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT ord_status_id_fkey FOREIGN KEY (ord_status_id) REFERENCES public.orders_status(ord_status_id);
 C   ALTER TABLE ONLY public.orders DROP CONSTRAINT ord_status_id_fkey;
       public          postgres    false    4709    227    229            q           2606    16549    orders orders_clientid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_clientid_fkey FOREIGN KEY (clientid) REFERENCES public.clients(clientid);
 E   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_clientid_fkey;
       public          postgres    false    215    4697    227            r           2606    16554    orders orders_engineerid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_engineerid_fkey FOREIGN KEY (engineerid) REFERENCES public.engineers(engineerid);
 G   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_engineerid_fkey;
       public          postgres    false    217    4699    227            s           2606    16559    orders orders_equipmentid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_equipmentid_fkey FOREIGN KEY (equipmentid) REFERENCES public.equipment(equipmentid);
 H   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_equipmentid_fkey;
       public          postgres    false    220    4701    227            t           2606    16564    orders orders_operatorid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_operatorid_fkey FOREIGN KEY (operatorid) REFERENCES public.operators(operatorid);
 G   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_operatorid_fkey;
       public          postgres    false    227    225    4705            u           2606    16569 &   orders orders_primaryinspectionid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_primaryinspectionid_fkey FOREIGN KEY (primaryinspectionid) REFERENCES public.primaryinspections(primaryinspectionid);
 P   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_primaryinspectionid_fkey;
       public          postgres    false    227    4711    231            v           2606    16574 6   primaryinspections primaryinspections_equipmentid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.primaryinspections
    ADD CONSTRAINT primaryinspections_equipmentid_fkey FOREIGN KEY (equipmentid) REFERENCES public.equipment(equipmentid);
 `   ALTER TABLE ONLY public.primaryinspections DROP CONSTRAINT primaryinspections_equipmentid_fkey;
       public          postgres    false    220    231    4701            w           2606    16579 5   primaryinspections primaryinspections_operatorid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.primaryinspections
    ADD CONSTRAINT primaryinspections_operatorid_fkey FOREIGN KEY (operatorid) REFERENCES public.operators(operatorid);
 _   ALTER TABLE ONLY public.primaryinspections DROP CONSTRAINT primaryinspections_operatorid_fkey;
       public          postgres    false    231    4705    225               M  x�]�An�P���)<�=�);O��y*AR��؝%i�I��M�0i{�ڨ�0�F���n�L&���|�-��c����+h;���e5��ˉ�G8�LǮ9�~�^%jY���˼݀�G���-�/<����)�SZ��"�ȗ���đ �z�
O���1�=��]�mGJ��h�ji���ڟt���ưID%��ᦪ�&�{J0|#�o���N+�&��l�;���#r��q�:����]h���������(�G�ZҵF�dv������<�j�R��]�%y��*ѷ�l�Yc�մ���(�Q_��ܺg��-��      	   �  x����J�@��'O��t�IƕO��Ik�Ѵ)Z���Vԅ��A�.�7���W8y�ē�P��.f`&�w�/� <�	>�z`�/8��i��'��{tx�Q~���|O�
���B��3�1�o�>Ӌ�����!�pT�<���[k�Jia�����v�����N"��6�i�"d8��Y~�+��y??�1��qX��?�!���鴗��)Pu�o�Ү��^�H��B��N /JUb�{P��a�a\32�=I�J�
Mɸe���4���Rkc J�V��q�&�"��e���h5Kt3�M�nX�JGB��d���9��G�FE���\6;�-gB0�IZ��|��BZ3����RZ)e���Z��v��iś��{F�'����&fx���_嬺��|�^X         �   x�]��N�@E�g�b 33KAV�B�ڪI_V%����F�/
-��>�l朹C�ӌX-l�
�{}�hא������0�
�1���C\U������򥉺�·�fn�yL���'�p���DW�Z�6V���"Cлݶ���=��^�I@��E���!XS-�mz����<���=H���'���ʚ��	L��z��s-��$"�W1qqY�y�Ͼm�����<�X�΄?k\         O   x�ɹ�0E�x�$�r(�@�!'�]�����UQ�S��;��%iR�L�xo�<$�������?�ظ�b�*(           x����J�@�ϓ��l���&YO>�O�K�P��	����=
�}Cm!��0�F�j�z/��,�7�-=ВZ蝖@�\����hAk;��Pg���Bj���:I3#AI�~*�z�3Zq��郃=���ΧgG���j���;H�1��T�q���(���<�V�"8,������#��;P���fL��h8��j/�0�798�ƞ�)���K/����f�,�B)��`�4ѱSF!��(+'�PN�yP�Y��q^ع���]k���ް��G��y����6         �   x�m�1�0Eg��"'N�v���cp Ą����# �#=�s#�R�������߉/
�U��j͔`q��XC�?t1Ξ�����_��0j���6�����u�&2A}(�BR�S?��C���K�C�|=_�~��ˑ�9'N�iү�)�hd�
&(k�dw!W�l9	��Z] a�v���aS;tA�`Q������v�{4V��         M   x�3估�®���_l���b��F.#�s.l�����\Ɯ�d.l���b?P���¬��/쿰�"F��� ��(�         �   x�u�1
�@E��)� *h�,����� ��^c������'HBC��
n�_A�b؝����n���V�
)2<%a��hdr��$�!F�Ʋ�R�����B6��G��p�Q��|9Y��b�B:C�EδZN��^4*"S��`K�ͧ�f`��)��8(>����~��@)k4��`Z?���ɞ���7���N�5�,r��o�� �U�R�q���         Z   x�m�;�0E�>U@�AL?,x �P �X����z>���Lπ���B�8Q�,�8�Q����Q�9��:=ao����a�����D�         �   x��9�@ �:yGj���޴Ty���%N!x=bډ��u:��<<���=�*�Ls��K�˗v�u���	�uk���yĖ�j���\	�I)�]-��KH�8Jt֬$^+ W�X�s�܁1�%�P����'���`q�q����!3     