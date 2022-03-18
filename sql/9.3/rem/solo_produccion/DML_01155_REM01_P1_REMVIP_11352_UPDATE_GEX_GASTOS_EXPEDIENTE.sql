--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11352
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  update de los  proveedores en expediente comercial y ofertas
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    PVE_ANTIGUO  NUMBER(16); -- Vble. para validar la existencia de un valor en una tabla. 
    PVE_NUEVO  NUMBER(16); -- Vble. para validar la existencia de un valor en una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := ''; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11352';
    V_COUNT NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('BK2218','1321'),
        T_TIPO_DATA('BK2219','6085'),
        T_TIPO_DATA('BK2220','3548'),
        T_TIPO_DATA('BK2221','3161'),
        T_TIPO_DATA('BK2222','6179'),
        T_TIPO_DATA('BK2223','4916'),
        T_TIPO_DATA('BK2224','5100'),
        T_TIPO_DATA('BK2225','3288'),
        T_TIPO_DATA('BK2226','3067'),
        T_TIPO_DATA('BK2227','4093'),
        T_TIPO_DATA('BK2228','1102'),
        T_TIPO_DATA('BK2229','4567'),
        T_TIPO_DATA('BK2230','3397'),
        T_TIPO_DATA('BK2231','3171'),
        T_TIPO_DATA('BK2232','2878'),
        T_TIPO_DATA('BK2233','4501'),
        T_TIPO_DATA('BK2234','4022'),
        T_TIPO_DATA('BK2235','6141'),
        T_TIPO_DATA('BK2236','2189'),
        T_TIPO_DATA('BK2237','5880'),
        T_TIPO_DATA('BK2238','3326'),
        T_TIPO_DATA('BK2239','4187'),
        T_TIPO_DATA('BK2240','3443'),
        T_TIPO_DATA('BK2241','1607'),
        T_TIPO_DATA('BK2242','452'),
        T_TIPO_DATA('BK2243','3551'),
        T_TIPO_DATA('BK2244','3840'),
        T_TIPO_DATA('BK2245','3644'),
        T_TIPO_DATA('BK2246','5671'),
        T_TIPO_DATA('BK2247','5937'),
        T_TIPO_DATA('BK2248','4391'),
        T_TIPO_DATA('BK2249','2543'),
        T_TIPO_DATA('BK2250','2970'),
        T_TIPO_DATA('BK2252','3142'),
        T_TIPO_DATA('BK2253','6835'),
        T_TIPO_DATA('BK2254','5712'),
        T_TIPO_DATA('BK2255','3083'),
        T_TIPO_DATA('BK2256','6194'),
        T_TIPO_DATA('BK2257','4045'),
        T_TIPO_DATA('BK2258','1953'),
        T_TIPO_DATA('BK2259','7499'),
        T_TIPO_DATA('BK2260','2708'),
        T_TIPO_DATA('BK2261','2556'),
        T_TIPO_DATA('BK2262','3312'),
        T_TIPO_DATA('BK2264','4123'),
        T_TIPO_DATA('BK2266','1611'),
        T_TIPO_DATA('BK2267','5986'),
        T_TIPO_DATA('BK2268','5644'),
        T_TIPO_DATA('BK2269','3548'),
        T_TIPO_DATA('BK2270','4196'),
        T_TIPO_DATA('BK2271','5049'),
        T_TIPO_DATA('BK2272','3352'),
        T_TIPO_DATA('BK2273','3267'),
        T_TIPO_DATA('BK2274','3649'),
        T_TIPO_DATA('BK2275','3975'),
        T_TIPO_DATA('BK2276','4914'),
        T_TIPO_DATA('BK2277','3362'),
        T_TIPO_DATA('BK2278','3363'),
        T_TIPO_DATA('BK2280','3451'),
        T_TIPO_DATA('BK2282','6118'),
        T_TIPO_DATA('BK2284','5935'),
        T_TIPO_DATA('BK2286','5413'),
        T_TIPO_DATA('BK2287','4744'),
        T_TIPO_DATA('BK2288','8337'),
        T_TIPO_DATA('BK2289','3643'),
        T_TIPO_DATA('BK2290','5974'),
        T_TIPO_DATA('BK2291','4108'),
        T_TIPO_DATA('BK2292','6894'),
        T_TIPO_DATA('BK2293','4560'),
        T_TIPO_DATA('BK2297','5646'),
        T_TIPO_DATA('BK2299','3830'),
        T_TIPO_DATA('BK2307','2538'),
        T_TIPO_DATA('BK2401','7930'),
        T_TIPO_DATA('BK2402','1801'),
        T_TIPO_DATA('BK2403','5796'),
        T_TIPO_DATA('BK2404','4071'),
        T_TIPO_DATA('BK2406','3329'),
        T_TIPO_DATA('BK2408','6093'),
        T_TIPO_DATA('BK2409','8334'),
        T_TIPO_DATA('BK2412','8338'),
        T_TIPO_DATA('BK2413','8344'),
        T_TIPO_DATA('BK2415','8345'),
        T_TIPO_DATA('BK2416','8346'),
        T_TIPO_DATA('BK2417','2004'),
        T_TIPO_DATA('BK2420','3703'),
        T_TIPO_DATA('BK2422','4111'),
        T_TIPO_DATA('BK2423','6226'),
        T_TIPO_DATA('BK2424','8333'),
        T_TIPO_DATA('BK2430','8335'),
        T_TIPO_DATA('BK2431','6107'),
        T_TIPO_DATA('BK2432','5094'),
        T_TIPO_DATA('BK2433','4447'),
        T_TIPO_DATA('BK2434','6812'),
        T_TIPO_DATA('BK2436','7956'),
        T_TIPO_DATA('BK2437','6390'),
        T_TIPO_DATA('BK2438','7940'),
        T_TIPO_DATA('BK2439','5936'),
        T_TIPO_DATA('BK2440','4655'),
        T_TIPO_DATA('BK2442','2881'),
        T_TIPO_DATA('BK2443','6877'),
        T_TIPO_DATA('BK2444','8019'),
        T_TIPO_DATA('BK2446','7027'),
        T_TIPO_DATA('BK2447','6860'),
        T_TIPO_DATA('BK2450','7951'),
        T_TIPO_DATA('BK2451','2799'),
        T_TIPO_DATA('BK2453','6851'),
        T_TIPO_DATA('BK2454','7050'),
        T_TIPO_DATA('BK2455','7289'),
        T_TIPO_DATA('BK2456','7971'),
        T_TIPO_DATA('BK2457','8029'),
        T_TIPO_DATA('BK2458','2972'),
        T_TIPO_DATA('BK2459','3253'),
        T_TIPO_DATA('BK2460','5492'),
        T_TIPO_DATA('BK2461','5905'),
        T_TIPO_DATA('BK2463','5920'),
        T_TIPO_DATA('BK2465','6106'),
        T_TIPO_DATA('BK2466','6148'),
        T_TIPO_DATA('BK2467','6215'),
        T_TIPO_DATA('BK2468','6832'),
        T_TIPO_DATA('BK2469','4155'),
        T_TIPO_DATA('BK2470','5867'),
        T_TIPO_DATA('BK2471','6042'),
        T_TIPO_DATA('BK2472','7058'),
        T_TIPO_DATA('BK2473','4050'),
        T_TIPO_DATA('BK2475','7037'),
        T_TIPO_DATA('BK2476','4910'),
        T_TIPO_DATA('BK2477','3117'),
        T_TIPO_DATA('BK2478','5102'),
        T_TIPO_DATA('BK2479','5672'),
        T_TIPO_DATA('BK2480','5916'),
        T_TIPO_DATA('BK2481','6145'),
        T_TIPO_DATA('BK2482','6185'),
        T_TIPO_DATA('BK2483','6233'),
        T_TIPO_DATA('BK2488','6251'),
        T_TIPO_DATA('BK2490','5620'),
        T_TIPO_DATA('BK2491','3236'),
        T_TIPO_DATA('BK2493','5946'),
        T_TIPO_DATA('BK2494','1964'),
        T_TIPO_DATA('BK2495','6073'),
        T_TIPO_DATA('BK2496','6308'),
        T_TIPO_DATA('BK2497','4401'),
        T_TIPO_DATA('BK2715','4819'),
        T_TIPO_DATA('BK2717','6038'),
        T_TIPO_DATA('BK2726','6119'),
        T_TIPO_DATA('BK2742','6167'),
        T_TIPO_DATA('BK2743','6171'),
        T_TIPO_DATA('BK2746','6173'),
        T_TIPO_DATA('BK2753','6826'),
        T_TIPO_DATA('BK2758','2078'),
        T_TIPO_DATA('BK2759','4829'),
        T_TIPO_DATA('BK2795','4502'),
        T_TIPO_DATA('BK2797','5528'),
        T_TIPO_DATA('BK2800','6001'),
        T_TIPO_DATA('BK2803','6090'),
        T_TIPO_DATA('BK2804','3548'),
        T_TIPO_DATA('BK2807','4580'),
        T_TIPO_DATA('BK2808','2015'),
        T_TIPO_DATA('BK2809','5854'),
        T_TIPO_DATA('BK2810','5870'),
        T_TIPO_DATA('BK2813','5977'),
        T_TIPO_DATA('BK2814','6043'),
        T_TIPO_DATA('BK2815','6188'),
        T_TIPO_DATA('BK2820','6240'),
        T_TIPO_DATA('BK2821','6055'),
        T_TIPO_DATA('BK2822','6279'),
        T_TIPO_DATA('BK2824','4350'),
        T_TIPO_DATA('BK2825','2972'),
        T_TIPO_DATA('BK2828','3297'),
        T_TIPO_DATA('BK2830','5896'),
        T_TIPO_DATA('BK2832','6165'),
        T_TIPO_DATA('BK2833','6194'),
        T_TIPO_DATA('BK2838','6198'),
        T_TIPO_DATA('BK2839','6342'),
        T_TIPO_DATA('BK2840','6894'),
        T_TIPO_DATA('BK2841','1927'),
        T_TIPO_DATA('BK2842','4602'),
        T_TIPO_DATA('BK2843','4482'),
        T_TIPO_DATA('BK2847','4234'),
        T_TIPO_DATA('BK2848','3457'),
        T_TIPO_DATA('BK2850','1149'),
        T_TIPO_DATA('BK2852','1337'),
        T_TIPO_DATA('BK2853','6062'),
        T_TIPO_DATA('BK2854','6193'),
        T_TIPO_DATA('BK2855','5440'),
        T_TIPO_DATA('BK2856','7951'),
        T_TIPO_DATA('BK2858','6097'),
        T_TIPO_DATA('BK2859','4980'),
        T_TIPO_DATA('BK2861','6229'),
        T_TIPO_DATA('BK2864','7931'),
        T_TIPO_DATA('BK2866','2966'),
        T_TIPO_DATA('BK2873','5614'),
        T_TIPO_DATA('BK2881','7943'),
        T_TIPO_DATA('BK2883','5848'),
        T_TIPO_DATA('BK2885','6232'),
        T_TIPO_DATA('BK2888','8020'),
        T_TIPO_DATA('BK2893','8021'),
        T_TIPO_DATA('BK2900','5813'),
        T_TIPO_DATA('BK2901','2395'),
        T_TIPO_DATA('BK2902','3367'),
        T_TIPO_DATA('BK2904','6366'),
        T_TIPO_DATA('BK2906','3192'),
        T_TIPO_DATA('BK2909','1267'),
        T_TIPO_DATA('BK2911','6099'),
        T_TIPO_DATA('BK2914','6292'),
        T_TIPO_DATA('BK2916','4921'),
        T_TIPO_DATA('BK2918','6345'),
        T_TIPO_DATA('BK2925','7058'),
        T_TIPO_DATA('BK2930','5497'),
        T_TIPO_DATA('BK2932','7286'),
        T_TIPO_DATA('BK2933','2067'),
        T_TIPO_DATA('BK2935','5834'),
        T_TIPO_DATA('BK2936','8222'),
        T_TIPO_DATA('BK2938','5637'),
        T_TIPO_DATA('BK2940','4218'),
        T_TIPO_DATA('BK2942','3821'),
        T_TIPO_DATA('BK2946','3838'),
        T_TIPO_DATA('BK2956','4967'),
        T_TIPO_DATA('BK2959','5661'),
        T_TIPO_DATA('BK2960','3773'),
        T_TIPO_DATA('BK2961','7935'),
        T_TIPO_DATA('BK2972','7980'),
        T_TIPO_DATA('BK2977','7985'),
        T_TIPO_DATA('BK2982','6137'),
        T_TIPO_DATA('BK2985','3161'),
        T_TIPO_DATA('BK2986','4924'),
        T_TIPO_DATA('BK2990','5707'),
        T_TIPO_DATA('BK2993','6308'),
        T_TIPO_DATA('BK2995','6363'),
        T_TIPO_DATA('BK2998','7972'),
        T_TIPO_DATA('BK3012','6264'),
        T_TIPO_DATA('BK3013','6904'),
        T_TIPO_DATA('BK3014','5919'),
        T_TIPO_DATA('BK3015','6391'),
        T_TIPO_DATA('BK3016','6878'),
        T_TIPO_DATA('BK3017','4899'),
        T_TIPO_DATA('BK3018','6834'),
        T_TIPO_DATA('BK3019','8180'),
        T_TIPO_DATA('BK3020','8182'),
        T_TIPO_DATA('BK3021','8184'),
        T_TIPO_DATA('BK3022','8193'),
        T_TIPO_DATA('BK3023','8235'),
        T_TIPO_DATA('BK3024','8236'),
        T_TIPO_DATA('BK3025','1545'),
        T_TIPO_DATA('BK3026','8321'),
        T_TIPO_DATA('BK3027','6278'),
        T_TIPO_DATA('BK3028','8146'),
        T_TIPO_DATA('BK3029','8160'),
        T_TIPO_DATA('BK3030','8163'),
        T_TIPO_DATA('BK3031','8173'),
        T_TIPO_DATA('BK3032','8188'),
        T_TIPO_DATA('BK3033','8224'),
        T_TIPO_DATA('BK3034','8232'),
        T_TIPO_DATA('BK3035','8164'),
        T_TIPO_DATA('BK3036','8171'),
        T_TIPO_DATA('BK3037','8196'),
        T_TIPO_DATA('BK3038','8203'),
        T_TIPO_DATA('BK3039','8213'),
        T_TIPO_DATA('BK3040','8216'),
        T_TIPO_DATA('BK3041','8220'),
        T_TIPO_DATA('BK3042','8229'),
        T_TIPO_DATA('BK3043','8192'),
        T_TIPO_DATA('BK3044','8226'),
        T_TIPO_DATA('BK3045','8234'),
        T_TIPO_DATA('BK3046','8264'),
        T_TIPO_DATA('BK3047','8279'),
        T_TIPO_DATA('BK3048','8305'),
        T_TIPO_DATA('BK3049','8326'),
        T_TIPO_DATA('BK3050','8328'),
        T_TIPO_DATA('BK3051','8205'),
        T_TIPO_DATA('BK3052','8215'),
        T_TIPO_DATA('BK3053','8221'),
        T_TIPO_DATA('BK3054','8282'),
        T_TIPO_DATA('BK3055','8225'),
        T_TIPO_DATA('BK3056','8228'),
        T_TIPO_DATA('BK3057','8238'),
        T_TIPO_DATA('BK3058','2839'),
        T_TIPO_DATA('BK3059','8258'),
        T_TIPO_DATA('BK3060','8245'),
        T_TIPO_DATA('BK3061','8275'),
        T_TIPO_DATA('BK3062','8285'),
        T_TIPO_DATA('BK3063','8288'),
        T_TIPO_DATA('BK3064','8324'),
        T_TIPO_DATA('BK3065','8329'),
        T_TIPO_DATA('BK3066','8330'),
        T_TIPO_DATA('BK3067','8178'),
        T_TIPO_DATA('BK3068','8200'),
        T_TIPO_DATA('BK3069','8242'),
        T_TIPO_DATA('BK3070','8278'),
        T_TIPO_DATA('BK3071','8280'),
        T_TIPO_DATA('BK3072','8311'),
        T_TIPO_DATA('BK3073','8312'),
        T_TIPO_DATA('BK3074','8331'),
        T_TIPO_DATA('BK3075','8148'),
        T_TIPO_DATA('BK3076','8210'),
        T_TIPO_DATA('BK3077','4644'),
        T_TIPO_DATA('BK3078','8269'),
        T_TIPO_DATA('BK3079','8295'),
        T_TIPO_DATA('BK3080','8308'),
        T_TIPO_DATA('BK3081','8317'),
        T_TIPO_DATA('BK3082','8259'),
        T_TIPO_DATA('BK3083','8261'),
        T_TIPO_DATA('BK3084','8273'),
        T_TIPO_DATA('BK3085','8282'),
        T_TIPO_DATA('BK3086','8283'),
        T_TIPO_DATA('BK3087','8286'),
        T_TIPO_DATA('BK3088','8303'),
        T_TIPO_DATA('BK3089','8313'),
        T_TIPO_DATA('BK3090','8240'),
        T_TIPO_DATA('BK3091','8244'),
        T_TIPO_DATA('BK3092','8255'),
        T_TIPO_DATA('BK3093','8265'),
        T_TIPO_DATA('BK3095','8266'),
        T_TIPO_DATA('BK3096','8270'),
        T_TIPO_DATA('BK3098','8276'),
        T_TIPO_DATA('BK3099','8301'),
        T_TIPO_DATA('BK3100','8241'),
        T_TIPO_DATA('BK3103','8262'),
        T_TIPO_DATA('BK3104','8263'),
        T_TIPO_DATA('BK3105','8267'),
        T_TIPO_DATA('BK3106','8309'),
        T_TIPO_DATA('BK3107','8315'),
        T_TIPO_DATA('BK3108','8316'),
        T_TIPO_DATA('BK3110','8323'),
        T_TIPO_DATA('BK3112','8253'),
        T_TIPO_DATA('BK3113','8257'),
        T_TIPO_DATA('BK3114','5809'),
        T_TIPO_DATA('BK3115','8298'),
        T_TIPO_DATA('BK3116','8299'),
        T_TIPO_DATA('BK3118','8302'),
        T_TIPO_DATA('BK3119','8307'),
        T_TIPO_DATA('BK3123','8319'),
        T_TIPO_DATA('BK3125','8250'),
        T_TIPO_DATA('BK3131','8272'),
        T_TIPO_DATA('BK3132','8287'),
        T_TIPO_DATA('BK3139','8300'),
        T_TIPO_DATA('BK3140','8310'),
        T_TIPO_DATA('BK3143','8314'),
        T_TIPO_DATA('BK3144','8325'),
        T_TIPO_DATA('BK3145','8327'),
        T_TIPO_DATA('BK3146','8159'),
        T_TIPO_DATA('BK3147','8190'),
        T_TIPO_DATA('BK3148','8248'),
        T_TIPO_DATA('BK3149','8252'),
        T_TIPO_DATA('BK3151','8271'),
        T_TIPO_DATA('BK3152','8297'),
        T_TIPO_DATA('BK3153','8318'),
        T_TIPO_DATA('BK3154','8322'),
        T_TIPO_DATA('BK3155','8243'),
        T_TIPO_DATA('BK3156','8260'),
        T_TIPO_DATA('BK3157','8274'),
        T_TIPO_DATA('BK3158','8284'),
        T_TIPO_DATA('BK3159','8291'),
        T_TIPO_DATA('BK3162','8292'),
        T_TIPO_DATA('BK3163','8293'),
        T_TIPO_DATA('BK3165','8296'),
        T_TIPO_DATA('BK3166','3965'),
        T_TIPO_DATA('BK3167','2932'),
        T_TIPO_DATA('BK3168','2933'),
        T_TIPO_DATA('BK3169','1395'),
        T_TIPO_DATA('BK3197','6807'),
        T_TIPO_DATA('BK3198','651'),
        T_TIPO_DATA('BK3199','8231'),
        T_TIPO_DATA('BK3200','1750'),
        T_TIPO_DATA('BK3201','4597'),
        T_TIPO_DATA('BK3203','3700'),
        T_TIPO_DATA('BK3206','3972'),
        T_TIPO_DATA('BK3207','1765'),
        T_TIPO_DATA('BK3209','1365'),
        T_TIPO_DATA('BK3210','8174'),
        T_TIPO_DATA('BK3217','8202'),
        T_TIPO_DATA('BK3219','1460'),
        T_TIPO_DATA('BK3221','8237'),
        T_TIPO_DATA('BK3222','8246'),
        T_TIPO_DATA('BK3223','8251'),
        T_TIPO_DATA('BK3224','8838'),
        T_TIPO_DATA('BK3227','8268'),
        T_TIPO_DATA('BK3228','8304'),
        T_TIPO_DATA('BK3231','8306'),
        T_TIPO_DATA('BK3233','278'),
        T_TIPO_DATA('BK3235','1720'),
        T_TIPO_DATA('BK3238','5327'),
        T_TIPO_DATA('BK3246','8183'),
        T_TIPO_DATA('BK3247','6285'),
        T_TIPO_DATA('BK3248','6367'),
        T_TIPO_DATA('BK3249','6910'),
        T_TIPO_DATA('BK3250','2549'),
        T_TIPO_DATA('BK3251','3892'),
        T_TIPO_DATA('BK3252','6392'),
        T_TIPO_DATA('BK3255','7938'),
        T_TIPO_DATA('BK3268','6214'),
        T_TIPO_DATA('BK3270','6372'),
        T_TIPO_DATA('BK3271','6882'),
        T_TIPO_DATA('BK3272','7043'),
        T_TIPO_DATA('BK3273','7963'),
        T_TIPO_DATA('BK3275','6268'),
        T_TIPO_DATA('BK3276','6864'),
        T_TIPO_DATA('BK3278','6868'),
        T_TIPO_DATA('BK3279','6899'),
        T_TIPO_DATA('BK3280','7929'),
        T_TIPO_DATA('BK3282','7945'),
        T_TIPO_DATA('BK3284','7962'),
        T_TIPO_DATA('BK3285','2607'),
        T_TIPO_DATA('BK3286','6216'),
        T_TIPO_DATA('BK3287','6888'),
        T_TIPO_DATA('BK3288','7925'),
        T_TIPO_DATA('BK3289','8009'),
        T_TIPO_DATA('BK3290','8076'),
        T_TIPO_DATA('BK3292','6169'),
        T_TIPO_DATA('BK3293','6227'),
        T_TIPO_DATA('BK3294','6302'),
        T_TIPO_DATA('BK3295','52'),
        T_TIPO_DATA('BK3297','7034'),
        T_TIPO_DATA('BK3298','7949'),
        T_TIPO_DATA('BK3299','2578'),
        T_TIPO_DATA('BK3300','6259'),
        T_TIPO_DATA('BK3301','6316'),
        T_TIPO_DATA('BK3302','7969'),
        T_TIPO_DATA('BK3303','7988'),
        T_TIPO_DATA('BK3304','8014'),
        T_TIPO_DATA('BK3305','5833'),
        T_TIPO_DATA('BK3306','6335'),
        T_TIPO_DATA('BK3307','8125'),
        T_TIPO_DATA('BK3308','3447'),
        T_TIPO_DATA('BK3309','5771'),
        T_TIPO_DATA('BK3310','6875'),
        T_TIPO_DATA('BK3311','7955'),
        T_TIPO_DATA('BK3312','7484'),
        T_TIPO_DATA('BK3313','5023'),
        T_TIPO_DATA('BK3314','8108'),
        T_TIPO_DATA('BK3315','4719'),
        T_TIPO_DATA('BK3317','8181'),
        T_TIPO_DATA('BK3318','6023'),
        T_TIPO_DATA('BK3319','6346'),
        T_TIPO_DATA('BK3320','3582'),
        T_TIPO_DATA('BK3321','8004'),
        T_TIPO_DATA('BK3322','8123'),
        T_TIPO_DATA('BK3323','8227'),
        T_TIPO_DATA('BK3324','8155'),
        T_TIPO_DATA('BK3325','8170'),
        T_TIPO_DATA('BK3326','8172'),
        T_TIPO_DATA('BK3327','3447'),
        T_TIPO_DATA('BK3329','6907'),
        T_TIPO_DATA('BK3330','8256'),
        T_TIPO_DATA('BK3332','8117'),
        T_TIPO_DATA('BK3333','8158'),
        T_TIPO_DATA('BK3334','8185'),
        T_TIPO_DATA('BK3335','8211'),
        T_TIPO_DATA('BK3339','8157'),
        T_TIPO_DATA('BK3340','6376'),
        T_TIPO_DATA('BK3341','8157'),
        T_TIPO_DATA('BK3343','8209'),
        T_TIPO_DATA('BK3345','8211'),
        T_TIPO_DATA('BK3346','8256'),
        T_TIPO_DATA('BK3347','8256'),
        T_TIPO_DATA('BK3352','8211'),
        T_TIPO_DATA('BK3355','8227'),
        T_TIPO_DATA('BK3358','8277'),
        T_TIPO_DATA('BK3362','8176'),
        T_TIPO_DATA('BK3363','8277'),
        T_TIPO_DATA('BK3364','8177'),
        T_TIPO_DATA('BK3375','8157'),
        T_TIPO_DATA('BK3380','8230'),
        T_TIPO_DATA('BK3381','3345'),
        T_TIPO_DATA('BK3383','5802'),
        T_TIPO_DATA('BK3384','6842'),
        T_TIPO_DATA('BK3385','8162'),
        T_TIPO_DATA('BK3386','8233'),
        T_TIPO_DATA('BK3387','5921'),
        T_TIPO_DATA('BK3388','7039'),
        T_TIPO_DATA('BK3389','7293'),
        T_TIPO_DATA('BK3390','4371'),
        T_TIPO_DATA('BK3391','6853'),
        T_TIPO_DATA('BK3392','4618'),
        T_TIPO_DATA('BK3393','8320'),
        T_TIPO_DATA('BK3394','8347'),
        T_TIPO_DATA('BK3395','8139'),
        T_TIPO_DATA('BK3396','8113'),
        T_TIPO_DATA('BK3397','6034'),
        T_TIPO_DATA('BK3398','6184'),
        T_TIPO_DATA('BK3399','6384'),
        T_TIPO_DATA('BK3400','6396'),
        T_TIPO_DATA('BK3401','7932'),
        T_TIPO_DATA('BK3402','8030'),
        T_TIPO_DATA('BK3403','6291'),
        T_TIPO_DATA('BK3404','6394'),
        T_TIPO_DATA('BK3405','6919'),
        T_TIPO_DATA('BK3406','7023'),
        T_TIPO_DATA('BK3407','7967'),
        T_TIPO_DATA('BK3408','7973'),
        T_TIPO_DATA('BK3409','6084'),
        T_TIPO_DATA('BK3410','6328'),
        T_TIPO_DATA('BK3411','6914'),
        T_TIPO_DATA('BK3413','7948'),
        T_TIPO_DATA('BK3414','6295'),
        T_TIPO_DATA('BK3415','6863'),
        T_TIPO_DATA('BK3416','3701'),
        T_TIPO_DATA('BK3417','8121'),
        T_TIPO_DATA('BK3418','8122'),
        T_TIPO_DATA('BK3425','8124'),
        T_TIPO_DATA('BK3426','8127'),
        T_TIPO_DATA('BK3429','5641'),
        T_TIPO_DATA('BK3430','6891'),
        T_TIPO_DATA('BK3431','8109'),
        T_TIPO_DATA('BK3432','4440'),
        T_TIPO_DATA('BK3433','8118'),
        T_TIPO_DATA('BK3434','2841'),
        T_TIPO_DATA('BK3435','3708'),
        T_TIPO_DATA('BK3437','8142'),
        T_TIPO_DATA('BK3438','56'),
        T_TIPO_DATA('BK3441','8143'),
        T_TIPO_DATA('BK3442','8154'),
        T_TIPO_DATA('BK3444','8165'),
        T_TIPO_DATA('BK3445','8207'),
        T_TIPO_DATA('BK3449','653'),
        T_TIPO_DATA('BK3454','4661'),
        T_TIPO_DATA('BK3457','4666'),
        T_TIPO_DATA('BK3458','4150'),
        T_TIPO_DATA('BK3460','5493'),
        T_TIPO_DATA('BK3461','7356'),
        T_TIPO_DATA('BK3462','7428'),
        T_TIPO_DATA('BK3463','7432'),
        T_TIPO_DATA('BK3465','7335'),
        T_TIPO_DATA('BK3466','7355'),
        T_TIPO_DATA('BK3469','7373'),
        T_TIPO_DATA('BK3470','7354'),
        T_TIPO_DATA('BK3471','7359'),
        T_TIPO_DATA('BK3472','7383'),
        T_TIPO_DATA('BK3476','7388'),
        T_TIPO_DATA('BK3477','7387'),
        T_TIPO_DATA('BK3480','3550'),
        T_TIPO_DATA('BK3482','7340'),
        T_TIPO_DATA('BK3483','7379'),
        T_TIPO_DATA('BK3486','7333'),
        T_TIPO_DATA('BK3487','479'),
        T_TIPO_DATA('BK3489','7384'),
        T_TIPO_DATA('BK3492','7352'),
        T_TIPO_DATA('BK3493','6327'),
        T_TIPO_DATA('BK3497','7334'),
        T_TIPO_DATA('BK3498','6078'),
        T_TIPO_DATA('BK3502','8024'),
        T_TIPO_DATA('BK3503','5992'),
        T_TIPO_DATA('BK3505','4224'),
        T_TIPO_DATA('BK3506','7465'),
        T_TIPO_DATA('BK3507','5814'),
        T_TIPO_DATA('BK3508','6241')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN TABLAS GEX_GASTOS_EXPEDIENTE y OFR_OFERTAS');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        PVE_ANTIGUO := 0;
        PVE_NUEVO := 0;

        --Comprobar el dato a updatear.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        DBMS_OUTPUT.PUT_LINE('[INFO]: V_MSQL ' || V_MSQL);
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        
        IF V_COUNT = 1 THEN

        V_MSQL := 'SELECT pve.PVE_ID FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO PVE_ANTIGUO;
        
        END IF;
        
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        
        IF V_COUNT = 1 THEN
        
        V_MSQL := 'SELECT pve.PVE_ID FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO PVE_NUEVO;
        
         END IF;

        -- Si existe se modifica.
        IF PVE_ANTIGUO != 0 AND PVE_NUEVO != 0 THEN		
                -- Actualiza GEX_GASTOS_EXPEDIENTE GEX_PROVEEDOR 
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  GEX_PROVEEDOR '''|| PVE_ANTIGUO ||''' A  '''|| PVE_NUEVO ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.GEX_GASTOS_EXPEDIENTE GEX
                            SET GEX.GEX_PROVEEDOR = '||PVE_NUEVO||'
                             , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                             , FECHAMODIFICAR = SYSDATE 
                            WHERE 
                                GEX.ECO_ID IN (SELECT ECO.ECO_ID FROM '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO 
                                                                    JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID 
                                                                    JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS_CAIXA OOC ON OOC.OFR_ID = OFR.OFR_ID  
                                                                    WHERE OOC.BORRADO = 0
                                                                        AND ECO.BORRADO = 0
                                                                        AND OFR.BORRADO = 0)
                                AND GEX.GEX_PROVEEDOR  = '||PVE_ANTIGUO||'
                                AND GEX.BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO GEX_PROVEEDOR MODIFICADO CORRECTAMENTE');
          

           
                -- Actualiza OFR_OFERTAS PVE_ID_PRESCRIPTOR 
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO EN TABLA OFR_OFERTAS PVE_ID_PRESCRIPTOR '''|| PVE_ANTIGUO ||''' A  '''|| PVE_NUEVO ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.OFR_OFERTAS ofr
                            SET ofr.PVE_ID_PRESCRIPTOR = '||PVE_NUEVO||'
                             , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                             , FECHAMODIFICAR = SYSDATE 
                            WHERE
                                ofr.OFR_ID IN (SELECT ofrcx.OFR_ID FROM OFR_OFERTAS_CAIXA ofrcx WHERE ofrcx.BORRADO = 0)
                                AND ofr.PVE_ID_PRESCRIPTOR  = '||PVE_ANTIGUO||'
                                AND ofr.BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO PVE_ID_PRESCRIPTOR MODIFICADO CORRECTAMENTE');

            
                -- Actualiza OFR_OFERTAS PVE_ID_CUSTODIO 
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO EN TABLA OFR_OFERTAS PVE_ID_CUSTODIO  '''|| PVE_ANTIGUO ||''' A  '''|| PVE_NUEVO ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.OFR_OFERTAS ofr
                            SET ofr.PVE_ID_CUSTODIO = '||PVE_NUEVO||'
                             , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                             , FECHAMODIFICAR = SYSDATE 
                            WHERE 
                            ofr.OFR_ID IN (SELECT ofrcx.OFR_ID FROM '|| V_ESQUEMA ||'.OFR_OFERTAS_CAIXA ofrcx WHERE ofrcx.BORRADO = 0)
                            AND ofr.PVE_ID_CUSTODIO  = '||PVE_ANTIGUO||'
                            AND ofr.BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO PVE_ID_CUSTODIO MODIFICADO CORRECTAMENTE');
       ELSE
       	-- Si no existe se actualiza.
          DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON PVE_COD_API_PROVEEDOR:  '||TRIM(V_TMP_TIPO_DATA(1))||' O '||TRIM(V_TMP_TIPO_DATA(2))||'');

       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
