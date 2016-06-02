<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>



var tabListener = function(title, flow, params,config){
    return {
        click : function(){
            
        var node=Ext.getCmp('admin_tree').getNodeById(this.id);
        var id=node.getPath();
        id = id.replace(/^\/[^/]*\//,"").replace(/\/.*$/,""); 
        node=Ext.getCmp('admin_tree').getNodeById(id);
        node.setText(node.getUI().getTextEl().innerHTML.replace(/<.?b>/g,""));
        app.openTab(title, flow, params,config); } 
    };
};

Ext.onReady(function() {
    var nodeStyle='padding-left:5px';
    var countTareas = [${countTareas[0]}, ${countTareas[1]},${countTareas[2]},${countTareas[3]},${countObjetivos} ];
    //TODO : esto se tiene que generar dinámicamente
    var nodos = [
                 { text : '<s:message code="main.arbol_tareas.pendientes" text="**Tareas pendientes" /><%-- (${countTareas[0]}) --%>'
                    ,id : 'arbol_tareas_nodo_pendientes'
                    ,leaf:false
                    ,style:nodeStyle                    
                    ,iconCls:'icon_pendientes'
                    ,listeners :tabListener("<s:message code="tareas.pendientes" text="**tareas pendientes"/>", "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'1',
                                    alerta:false,                                   
                                    espera:false,
                                    titulo:"<s:message code="tareas.pendientes" text="**tareas pendientes"/>",
                                    icon:'icon_pendientes_tab'
                                },
                                {id:'tareas_pendientes',iconCls:'icon_pendientes_tab',closable:true})
                    ,children:[
                        {
                            text:'<s:message code="main.arbol_tareas.groups.vencidas" text="**Vencidas / Incumplidas " />'
                            //,listeners:
                            ,iconCls:'icon_pendientes'
                            ,style:nodeStyle,leaf:true
                            ,listeners: tabListener("<s:message code="tareas.pendientes" text="**tareas pendientes"/>", "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'1'
                                    ,alerta:false
                                    ,espera:false
                                    ,titulo:"<s:message code="tareas.pendientes" text="**tareas pendientes"/>"
                                    ,icon:'icon_pendientes_tab'
                                    ,isBusqueda:true
                                    ,noGrouping:true
                                    ,fechaVencHasta:app.format.dateRenderer(new Date().add(Date.DAY, -1))
                                    ,fechaVencHastaOp:'<='
                                    ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.vencidas" text="**Vencidas / Incumplidas " />'
                                },
                                {id:'tareas_pendientes',iconCls:'icon_pendientes_tab'})
                        },{
                            text:'<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" /> '
                            //,listeners:
                            ,iconCls:'icon_pendientes'
                            ,style:nodeStyle,leaf:true
                            ,listeners: tabListener("<s:message code="tareas.pendientes" text="**tareas pendientes"/>", "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'1'
                                    ,alerta:false
                                    ,espera:false
                                    ,titulo:"<s:message code="tareas.pendientes" text="**tareas pendientes"/>"
                                    ,icon:'icon_pendientes_tab'
                                    ,isBusqueda:true
                                    ,noGrouping:true
                                    ,fechaVencDesde:app.format.dateRenderer(new Date())
                                    ,fechaVencDesdeOp:'='
                                    ,fechaVencHasta:app.format.dateRenderer(new Date())
                                    ,fechaVencHastaOp:'='
                                    ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" /> '
                                },
                                {id:'tareas_pendientes',iconCls:'icon_pendientes_tab'})
                        },{
                            text:'<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" /> '
                            //,listeners:
                            ,iconCls:'icon_pendientes'
                            ,style:nodeStyle,leaf:true
                            ,listeners: tabListener("<s:message code="tareas.pendientes" text="**tareas pendientes"/>", "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'1'
                                    ,alerta:false
                                    ,espera:false
                                    ,titulo:"<s:message code="tareas.pendientes" text="**tareas pendientes"/>"
                                    ,icon:'icon_pendientes_tab'
                                    ,isBusqueda:true
                                    ,noGrouping:true
                                    ,fechaVencDesde:app.format.dateRenderer((app.getFirstDateOfWeek(new Date())).add(Date.DAY,1))
                                    ,fechaVencDesdeOp:'>='
                                    ,fechaVencHasta:app.format.dateRenderer((app.getLastDateOfWeek(new Date())).add(Date.DAY,1))
                                    ,fechaVencHastaOp:'<='
                                    //,traerGestionVencidos:true
                                    ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" /> '
                                },
                                {id:'tareas_pendientes',iconCls:'icon_pendientes_tab'})
                        },{
                            text:'<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" />'
                            //,listeners:
                            ,iconCls:'icon_pendientes'
                            ,style:nodeStyle,leaf:true
                            ,listeners: tabListener("<s:message code="tareas.pendientes" text="**tareas pendientes"/>", "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'1'
                                    ,alerta:false
                                    ,espera:false
                                    ,titulo:"<s:message code="tareas.pendientes" text="**tareas pendientes"/>"
                                    ,icon:'icon_pendientes_tab'
                                    ,isBusqueda:true
                                    ,noGrouping:true
                                    ,fechaVencDesde:app.format.dateRenderer(new Date().getFirstDateOfMonth())
                                    ,fechaVencDesdeOp:'>='
                                    ,fechaVencHasta:app.format.dateRenderer(new Date().getLastDateOfMonth())
                                    ,fechaVencHastaOp:'<='
                                    ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" />'
                                },
                                {id:'tareas_pendientes',iconCls:'icon_pendientes_tab'})
                        },{
                            text:'<s:message code="main.arbol_tareas.groups.proximosmeses" text="**Proximos meses" /> '
                            //,listeners:
                            ,iconCls:'icon_pendientes'
                            ,style:nodeStyle,leaf:true
                            ,listeners: tabListener("<s:message code="tareas.pendientes" text="**tareas pendientes"/>", "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'1'
                                    ,alerta:false
                                    ,espera:false
                                    ,titulo:"<s:message code="tareas.pendientes" text="**tareas pendientes"/>"
                                    ,icon:'icon_pendientes_tab'
                                    ,isBusqueda:true
                                    ,noGrouping:true
                                    ,fechaVencDesde:app.format.dateRenderer((new Date().getLastDateOfMonth()).add(Date.DAY,1))
                                    ,fechaVencDesdeOp:'>='
                                    ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.proximosmeses" text="**Proximos meses" /> '
                                },
                                {id:'tareas_pendientes',iconCls:'icon_pendientes_tab'})
                        }
                    ]
                 }
                 ,{ text : '<s:message code="main.arbol_tareas.espera" text="**Tareas espera" /><%-- (${countTareas[1]}) --%>'
                    ,id : 'arbol_tareas_nodo_espera'
                    ,leaf:false
                    ,style:nodeStyle
                    ,iconCls:'icon_espera'
                    ,listeners :tabListener("<s:message code="tareas.enespera" text="**tareas en espera"/>", "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'1',
                                    alerta:false,
                                    espera:true,
                                    titulo:"<s:message code="tareas.enespera" text="**tareas en espera"/>",
                                    icon:'icon_espera_tab'
                                    
                                },
                                {id:'tareas_espera',iconCls:'icon_espera_tab'})
                    ,children:[
                        {
                                text:'<s:message code="main.arbol_tareas.groups.vencidas" text="**Vencidas / Incumplidas " />'
                                //,listeners:
                                ,iconCls:'icon_espera'
                                ,style:nodeStyle
                                ,leaf:true
                                ,listeners: tabListener('<s:message code="tareas.enespera" text="**tareas en espera"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:false
                                        ,espera:true
                                        ,titulo:'<s:message code="tareas.enespera" text="**tareas en espera"/>'
                                        ,icon:'icon_espera_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencHasta:app.format.dateRenderer(new Date().add(Date.DAY, -1))
                                        ,fechaVencHastaOp:'<='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.vencidas" text="**Vencidas / Incumplidas " />'
                                    },
                                    {id:'tareas_espera',iconCls:'icon_espera_tab'})
                            },{
                                text:'<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" /> '
                                //,listeners:
                                ,iconCls:'icon_espera'
                                ,style:nodeStyle,leaf:true
                                ,listeners: tabListener('<s:message code="tareas.enespera" text="**tareas en espera"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:false
                                        ,espera:true
                                        ,titulo:'<s:message code="tareas.enespera" text="**tareas en espera"/>'
                                        ,icon:'icon_espera_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencDesde:app.format.dateRenderer(new Date())
                                        ,fechaVencDesdeOp:'='
                                        ,fechaVencHasta:app.format.dateRenderer(new Date())
                                        ,fechaVencHastaOp:'='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" /> '
                                    },
                                    {id:'tareas_espera',iconCls:'icon_espera_tab'})
                            },{
                                text:'<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" /> '
                                //,listeners:
                                ,iconCls:'icon_espera'
                                ,style:nodeStyle,leaf:true
                                ,listeners: tabListener('<s:message code="tareas.enespera" text="**tareas en espera"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:false
                                        ,espera:true
                                        ,titulo:'<s:message code="tareas.enespera" text="**tareas en espera"/>'
                                        ,icon:'icon_espera_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencDesde:app.format.dateRenderer((app.getFirstDateOfWeek(new Date())).add(Date.DAY,1))
                                        ,fechaVencDesdeOp:'>='
                                        ,fechaVencHasta:app.format.dateRenderer((app.getLastDateOfWeek(new Date())).add(Date.DAY,1))
                                        ,fechaVencHastaOp:'<='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" /> '
                                    },
                                    {id:'tareas_espera',iconCls:'icon_espera_tab'})
                            },{
                                text:'<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" /> '
                                //,listeners:
                                ,iconCls:'icon_espera'
                                ,style:nodeStyle,leaf:true
                                ,listeners: tabListener('<s:message code="tareas.enespera" text="**tareas en espera"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:false
                                        ,espera:true
                                        ,titulo:'<s:message code="tareas.enespera" text="**tareas en espera"/>'
                                        ,icon:'icon_espera_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencDesde:app.format.dateRenderer(new Date().getFirstDateOfMonth())
                                        ,fechaVencDesdeOp:'>='
                                        ,fechaVencHasta:app.format.dateRenderer(new Date().getLastDateOfMonth())
                                        ,fechaVencHastaOp:'<='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" /> '
                                    },
                                    {id:'tareas_espera',iconCls:'icon_espera_tab'})
                            },{
                                text:'<s:message code="main.arbol_tareas.groups.proximosmeses" text="**Proximos meses" />'
                                //,listeners:
                                ,iconCls:'icon_espera'
                                ,style:nodeStyle,leaf:true
                                ,listeners: tabListener('<s:message code="tareas.enespera" text="**tareas en espera"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:false
                                        ,espera:true
                                        ,titulo:'<s:message code="tareas.enespera" text="**tareas en espera"/>'
                                        ,icon:'icon_espera_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencDesde:app.format.dateRenderer((new Date().getLastDateOfMonth()).add(Date.DAY,1))
                                        ,fechaVencDesdeOp:'>='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.proximosmeses" text="**Proximos meses" />'
                                    },
                                    {id:'tareas_espera',iconCls:'icon_espera_tab'})
                        }
                    ]
                 },{
                    text: '<s:message code="main.arbol_tareas.notificaciones" text="**Notificaciones" /><%-- (${countTareas[2]}) --%>'
                    ,id:'notificaciones'
                    ,leaf : false
                    ,style:nodeStyle
                    ,iconCls:'icon_comunicacion'
                    ,listeners :tabListener("<s:message code="tareas.notificaciones" text="**Notificaciones"/>", "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'3',
                                    alerta:false,
                                    espera:false,
                                    titulo:"<s:message code="tareas.notificaciones" text="**Notificaciones"/>",
                                    icon:'icon_comunicacion_tab'
                                },
                                {id:'tareas_notificaciones',iconCls:'icon_comunicacion_tab'})
                    
                    ,children:[
                        {
                            text:'<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" /> '
                            //,listeners:
                            ,iconCls:'icon_comunicacion'
                            ,style:nodeStyle,leaf:true
                            ,listeners: tabListener('<s:message code="tareas.notificaciones" text="**Notificaciones"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'3'
                                    ,alerta:false
                                    ,espera:false
                                    ,titulo:'<s:message code="tareas.notificaciones" text="**Notificaciones"/>'
                                    ,icon:'icon_comunicacion_tab'
                                    ,isBusqueda:true
                                    ,noGrouping:true
                                    ,fechaVencDesde:app.format.dateRenderer(new Date())
                                    ,fechaVencDesdeOp:'='
                                    ,fechaVencHasta:app.format.dateRenderer(new Date())
                                    ,fechaVencHastaOp:'='
                                    ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" /> '
                                },
                                {id:'tareas_notificaciones',iconCls:'icon_comunicacion_tab'})
                        },{
                            text:'<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" /> '
                            //,listeners:
                            ,iconCls:'icon_comunicacion'
                            ,style:nodeStyle,leaf:true
                            ,listeners: tabListener('<s:message code="tareas.notificaciones" text="**Notificaciones"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'3'
                                    ,alerta:false
                                    ,espera:false
                                    ,titulo:'<s:message code="tareas.notificaciones" text="**Notificaciones"/>'
                                    ,icon:'icon_comunicacion_tab'
                                    ,isBusqueda:true
                                    ,noGrouping:true
                                    ,fechaVencDesde:app.format.dateRenderer((app.getFirstDateOfWeek(new Date())).add(Date.DAY,1))
                                    ,fechaVencDesdeOp:'>='
                                    ,fechaVencHasta:app.format.dateRenderer((app.getLastDateOfWeek(new Date())).add(Date.DAY,1))
                                    ,fechaVencHastaOp:'<='
                                    ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" /> '
                                },
                                {id:'tareas_notificaciones',iconCls:'icon_comunicacion_tab'})
                        },{
                            text:'<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" /> '
                            //,listeners:
                            ,iconCls:'icon_comunicacion'
                            ,style:nodeStyle,leaf:true
                            ,listeners: tabListener('<s:message code="tareas.notificaciones" text="**Notificaciones"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'3'
                                    ,alerta:false
                                    ,espera:false
                                    ,titulo:'<s:message code="tareas.notificaciones" text="**Notificaciones"/>'
                                    ,icon:'icon_comunicacion_tab'
                                    ,isBusqueda:true
                                    ,noGrouping:true
                                    ,fechaVencDesde:app.format.dateRenderer(new Date().getFirstDateOfMonth())
                                    ,fechaVencDesdeOp:'>='
                                    ,fechaVencHasta:app.format.dateRenderer(new Date().getLastDateOfMonth())
                                    ,fechaVencHastaOp:'<='
                                    ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" /> '
                                },
                                {id:'tareas_notificaciones',iconCls:'icon_comunicacion_tab'})
                        },{
                            text:'<s:message code="main.arbol_tareas.groups.mesesanteriores" text="**meses anteriores" /> '
                            //,listeners:
                            ,iconCls:'icon_comunicacion'
                            ,style:nodeStyle,leaf:true
                            ,listeners: tabListener('<s:message code="tareas.notificaciones" text="**Notificaciones"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'3'
                                    ,alerta:false
                                    ,espera:false
                                    ,titulo:'<s:message code="tareas.notificaciones" text="**Notificaciones"/>'
                                    ,icon:'icon_comunicacion_tab'
                                    ,isBusqueda:true
                                    ,noGrouping:true
                                    ,fechaVencHasta:app.format.dateRenderer((new Date().getFirstDateOfMonth()).add(Date.DAY,-1))
                                    ,fechaVencHastaOp:'<='
                                    ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.mesesanteriores" text="**meses anteriores" /> '
                                },
                                {id:'tareas_notificaciones',iconCls:'icon_comunicacion_tab'})
                        }
                    ]
                }
<sec:authorize ifNotGranted="MENU_PROCURADORES_GENERAL">
                ,{
                    text: '<s:message code="main.arbol_tareas.alertas" text="**Alertas" /><%--  (${countTareas[3]})--%>'
                    ,id : 'arbol_tareas_nodo_alertas'
                    ,leaf : false
                    ,style:nodeStyle
                    ,iconCls:'icon_alerta'
                    ,listeners :tabListener('<s:message code="tareas.alertas" text="**Alertas"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                {
                                    codigoTipoTarea:'1',
                                    alerta:true,
                                    espera:false,
                                    titulo:"<s:message code="tareas.alertas" text="**Alertas"/>",
                                    icon:'icon_alerta_tab'
                                },
                                {id:'tareas_alertas',iconCls:'icon_alerta_tab'})
                    ,children:[
                        {
                                text:'<s:message code="main.arbol_tareas.groups.vencidas" text="**Vencidas / Incumplidas " />'
                                //,listeners:
                                ,iconCls:'icon_alerta'
                                ,style:nodeStyle
                                ,leaf:true
                                ,listeners: tabListener("<s:message code="tareas.alertas" text="**Alertas"/>", "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:true
                                        ,espera:false
                                        ,titulo:"<s:message code="tareas.alertas" text="**Alertas"/>"
                                        ,icon:'icon_alerta_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencHasta:app.format.dateRenderer((new Date()).add(Date.DAY,-1))
                                        ,fechaVencHastaOp:'<='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.vencidas" text="**Vencidas / Incumplidas " />'
                                    },
                                    {id:'tareas_alertas',iconCls:'icon_alerta_tab'})
                            },{
                                text:'<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" /> '
                                //,listeners:
                                ,iconCls:'icon_alerta'
                                ,style:nodeStyle,leaf:true
                                ,listeners: tabListener('<s:message code="tareas.alertas" text="**Alertas"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:true
                                        ,espera:false
                                        ,titulo:'<s:message code="tareas.alertas" text="**Alertas"/>'
                                        ,icon:'icon_alerta_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencDesde:app.format.dateRenderer(new Date())
                                        ,fechaVencDesdeOp:'='
                                        ,fechaVencHasta:app.format.dateRenderer(new Date())
                                        ,fechaVencHastaOp:'='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" /> '
                                    },
                                    {id:'tareas_alertas',iconCls:'icon_alerta_tab'})
                            },{
                                text:'<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" />'
                                //,listeners:
                                ,iconCls:'icon_alerta'
                                ,style:nodeStyle,leaf:true
                                ,listeners: tabListener('<s:message code="tareas.alertas" text="**Alertas"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:true
                                        ,espera:false
                                        ,titulo:'<s:message code="tareas.alertas" text="**Alertas"/>'
                                        ,icon:'icon_alerta_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencDesde:app.format.dateRenderer((app.getFirstDateOfWeek(new Date())).add(Date.DAY,1))
                                        ,fechaVencDesdeOp:'>='
                                        ,fechaVencHasta:app.format.dateRenderer((app.getLastDateOfWeek(new Date())).add(Date.DAY,1))
                                        ,fechaVencHastaOp:'<='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" />'
                                    },
                                    
                                    {id:'tareas_alertas',iconCls:'icon_alerta_tab'})
                            },{
                                text:'<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" />'
                                //,listeners:
                                ,iconCls:'icon_alerta'
                                ,style:nodeStyle,leaf:true
                                ,listeners: tabListener('<s:message code="tareas.alertas" text="**Alertas"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:true
                                        ,espera:false
                                        ,titulo:'<s:message code="tareas.alertas" text="**Alertas"/>'
                                        ,icon:'icon_alerta_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencDesde:app.format.dateRenderer(new Date().getFirstDateOfMonth())
                                        ,fechaVencDesdeOp:'>='
                                        ,fechaVencHasta:app.format.dateRenderer(new Date().getLastDateOfMonth())
                                        ,fechaVencHastaOp:'<='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" />'
                                    },
                                    {id:'tareas_alertas',iconCls:'icon_alerta_tab'})
                            },{
                                text:'<s:message code="main.arbol_tareas.groups.proximosmeses" text="**Proximos meses" />'
                                //,listeners:
                                ,iconCls:'icon_alerta'
                                ,style:nodeStyle,leaf:true
                                ,listeners: tabListener('<s:message code="tareas.alertas" text="**Alertas"/>', "plugin/mejoras/tareas/MEJlistadoTareas",
                                    {
                                        codigoTipoTarea:'1'
                                        ,alerta:true
                                        ,espera:false
                                        ,titulo:'<s:message code="tareas.alertas" text="**Alertas"/>'
                                        ,icon:'icon_alerta_tab'
                                        ,isBusqueda:true
                                        ,noGrouping:true
                                        ,fechaVencDesde:app.format.dateRenderer((new Date().getLastDateOfMonth()).add(Date.DAY,1))
                                        ,fechaVencDesdeOp:'>='
                                        ,tituloAdicionalGrid:'<s:message code="main.arbol_tareas.groups.proximosmeses" text="**Proximos meses" />'
                                    },
                                    {id:'tareas_alertas',iconCls:'icon_alerta_tab'})
                        }
                    ]
                 }
</sec:authorize>
<sec:authorize ifAllGranted="ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES">
                 ,{
                                text:"<s:message code="tareas.gc" text="**Gesti&oacute;n de Clientes"/>"
                                //,listeners:
                                ,iconCls:'icon_gv_tree'
                                ,style:nodeStyle
                                ,leaf:true
                                ,listeners:tabListener(
                                    "<s:message code="tareas.gc" text="**Gesti&oacute;n de Clientes"/>"
                                    , "gestionclientes/getListadoGestionClientes",{},
                                    {id:'gestion_clientes',iconCls:'icon_gv_tree'})
                                
                }
</sec:authorize>
<sec:authorize ifAllGranted="ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES">
                ,{
                    text:'<s:message code="main.arbol_tareas.groups.objetivos" text="**Objetivos Pendientes" /> (${countObjetivos})'
                    //,listeners:
                    ,id : 'arbol_tareas_nodo_objetivos'
                    ,iconCls:'icon_objetivos_pendientes'
                    ,style:nodeStyle,leaf:true
                    ,listeners: tabListener("<s:message code="main.arbol_tareas.groups.objetivos" text="**Objetivos Pendientes"/>", "tareas/listadoObjetivosGestor",{},
                        {id:'objetivos_pendientes',iconCls:'icon_objetivos_pendientes_tab'})
                }
</sec:authorize>
    ];
    
    /*var btnReload = new Ext.Button({
        text : '<s:message code="app.recargar" text="**recargar" />'
        ,iconCls : 'fwk_recargar'
        ,cls: 'x-btn-text-icon'
        ,handler: recargaTarea
    });*/
    
    /*Recupero los nodos dinámicos, si existen.*/
    var nodosDinamicos = <app:includeArray files="${nodosDinamicos}" />;
    
    var tree = new Ext.tree.TreePanel({
        id : 'admin_tree'
        ,animate : true
        ,autoHeight : true
        ,border : false
        ,autoScroll : true
        ,loader : new Ext.tree.TreeLoader()
        ,containerScroll : true
        //,tbar : [ btnReload ]
    });


    var root = new Ext.tree.AsyncTreeNode({
        leaf : false,
        id:'arbolTareas',
        //loaded : true,
        expanded : true,
        text : '<s:message code="main.arbol_tareas.raiz" text="" />',
        children : nodos
    });

    tree.setRootNode(root);
    page.add(tree);

    tree.render();
    root.expand();

    /*Añadimos los nodos dinámicos al árbol*/
    if (nodosDinamicos.length > 0){
        root.appendChild(nodosDinamicos);
        for(var i=0;i < nodosDinamicos.length;i++){
            /*Inicializamos los objetos en caso de disponer de la funcion init()*/
            if (typeof nodosDinamicos[i].init == 'function'){
                    nodosDinamicos[i].init();
            }
        }
    }
        
    /* recarga del árbol de tareas */
    app.recargaTree = function(){
        var id=Ext.getCmp("tareas").el.child('.x-panel').id;
              Ext.getCmp("tareas").remove(id,true);

        Ext.getCmp("tareas").load({
            url : 'main/arbol_tareas.htm' 
            ,scripts:true
        });

    };

    var actualizarTareas = function(datos){
                var tareas = Ext.decode(datos.countTareas);
                var strToast="";
                tareas[4] = datos.countObjetivos;
                
                if (tareas[0]>countTareas[0]){
                     strToast += "<s:message code="main.arbol_tareas.nuevas_tareas_pendientes" text="**Nuevas Tareas pendientes" /><br/>";
                    tree.getNodeById('arbol_tareas_nodo_pendientes').setText('<b><s:message code="main.arbol_tareas.pendientes" text="**Tareas pendientes" /> (' +tareas[0]+")</b>");
                }
                if (tareas[1]>countTareas[1]){
                     strToast += "<s:message code="main.arbol_tareas.nuevas_tareas_espera" text="**Nuevas tareas en espera" /><br/>";
                    tree.getNodeById('arbol_tareas_nodo_espera').setText('<b><s:message code="main.arbol_tareas.espera" text="**Tareas espera" /> (' +tareas[1]+")</b>");
                }
                if (tareas[2]>countTareas[2]){
                    strToast += "<s:message code="main.arbol_tareas.nuevas_tareas_notificaciones" text="**Nuevas notificaciones" /><br/>";
                    tree.getNodeById('notificaciones').setText('<b><s:message code="main.arbol_tareas.notificaciones" text="**Notificaciones" /> (' +tareas[2]+")</b>");
                 }
<sec:authorize ifNotGranted="MENU_PROCURADORES_GENERAL">
                if (tareas[3]>countTareas[3]){
                     strToast += "<s:message code="main.arbol_tareas.nuevas_tareas_alertas" text="**Nuevas alertas" /><br/>";
                    tree.getNodeById('arbol_tareas_nodo_alertas').setText('<b><s:message code="main.arbol_tareas.alertas" text="**Alertas" /> (' +tareas[3]+")</b>");
                }
</sec:authorize>  
<sec:authorize ifAllGranted="ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES">
                if (tareas[4]>countTareas[4]){
                     strToast += "<s:message code="main.arbol_tareas.nuevos_objetivos" text="**Nuevos objetivos" /><br/>";
                    tree.getNodeById('arbol_tareas_nodo_objetivos').setText('<b><s:message code="main.arbol_tareas.groups.objetivos" text="**Objetivos Pendientes" /> (' +tareas[4]+")</b>");
                }
</sec:authorize>                
                if (strToast.length>0) fwk.toast(strToast);
                countTareas=tareas;
            };
            
     /*app.recargaTree = function(){
     	<%--FIXME BORRAR ESTA FUNCIÓN --%>
     	var a = 0;
     };*/       
<%--
    app.recargaTree = function(){
        page.webflow({
            flow:"main/arbol_tareasJSON"
            ,success: actualizarTareas
        });
    }

    //ejecutamos tras un timeout
//  setTimeout(app.recargaTree, ${appProperties.arbolTareasTiempoRecarga});

    var recargaDatos = function(){
        page.webflow({
            flow:"main/arbol_tareasJSON"
            ,success: function(datos){
                actualizarTareas(datos);
               setTimeout(recargaDatos, ${appProperties.arbolTareasTiempoRecarga});
            }   
        });
    };
    
    setTimeout(recargaDatos, ${appProperties.arbolTareasTiempoRecarga});
 --%>
    var old_previsiones = 0;
    
});
</fwk:page>