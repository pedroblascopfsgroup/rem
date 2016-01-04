<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var estadoPoliticaStore;
var pPrePolitica;
var pCEPolitica;
var pREPolitica;
var pDCPolitica;
var pVigentePolitica;
var pSeleccionado;
var idEstado;
var rechazable;
var esGestorObjetivos = false;
var esSupervisorObjetivos = false;
var esGestorExpediente = false;
var esSupervisorExpediente = false;

Ext.Button.override({
   setTooltip: function(qtipText) {
       var btnEl = this.getEl().child(this.buttonSelector)
       Ext.QuickTips.register({
           target: btnEl.id,
           text: qtipText
       });             
   }
});


var cargarObjetivos = function(panel) {
	Ext.select('.bordeActivo').replaceClass('bordeActivo', 'bordeInactivo');
	panel.getEl().replaceClass('bordeInactivo', 'bordeActivo');

    pSeleccionado = panel;
    
    idPolitica = panel.items.items[6].getValue();
    
    if(idPolitica == null || idPolitica == '') {
        idPolitica = -1;
    }
    
    objetivosGrid.getBottomToolbar().disable();
    rechazable = false;
    objetivosStore.webflow({idPolitica:idPolitica});

	compruebaPermisosStore.webflow({idPolitica:idPolitica});
}

var createDatosPoliticaPanel = function() {
//----------------------------------------------------------------------
// Botones
//----------------------------------------------------------------------
    var btnPrePolitica = new Ext.Button({
        text : '<s:message code="politica.boton.prePolitica" text="**Prepolitica" />'
        ,iconCls : 'icon_pendientes'
        ,height:20
        ,handler:function(){cargarObjetivos(pPrePolitica)}
    });
 
    var btnCEPolitica = new Ext.Button({
        text : '<s:message code="politica.boton.cePolitica" text="**CE Politica" />'
        ,bodyStyle:'padding:10px;cellspacing:10px'
        ,iconCls : 'icon_pendientes'
        ,height:20
        ,handler:function(){cargarObjetivos(pCEPolitica)}
    });

    var btnREPolitica = new Ext.Button({
        text : '<s:message code="politica.boton.rePolitica" text="**RE Politica" />'
        ,iconCls : 'icon_pendientes'
        ,height:20
        ,handler:function(){cargarObjetivos(pREPolitica)}
    });

    var btnDCPolitica = new Ext.Button({
        text : '<s:message code="politica.boton.dcPolitica" text="**DC Politica" />'
        ,iconCls : 'icon_pendientes'
        ,height:20
        ,handler:function(){cargarObjetivos(pDCPolitica)}
    });

    var btnVigPolitica = new Ext.Button({
        text : '<s:message code="politica.boton.vigente" text="**Vigente" />'
        ,iconCls : 'icon_pendientes'
        ,height:20
        ,handler:function(){cargarObjetivos(pVigentePolitica)}
    });


//----------------------------------------------------------------------
// Permisos usuarios
//----------------------------------------------------------------------

 var permisoUsuario = Ext.data.Record.create([
        {name : 'esGestorObjetivos'}
        ,{name : 'esSupervisorObjetivos'}
        ,{name : 'esVigente'}
        ,{name : 'esPropuesta'}
        ,{name : 'esPropuestaSuperusuario'}
        ,{name : 'esGestorExpediente'}
        ,{name : 'esSupervisorExpediente'}
    ]);

    compruebaPermisosStore = page.getStore({
        event:'permisos'
        ,flow : 'politica/compruebaPermisosUsuario'
        ,reader : new Ext.data.JsonReader(
            {root:'permisoUsuario'}
            , permisoUsuario
        )       
    });


	compruebaPermisosStore.on('load', function()
	{
		var rec = compruebaPermisosStore.getAt(0);
		esGestorObjetivos = rec.get('esGestorObjetivos');
		esSupervisorObjetivos = rec.get('esSupervisorObjetivos');
		
		esGestorExpediente = rec.get('esGestorExpediente');
		esSupervisorExpediente = rec.get('esSupervisorExpediente');
		
		var esVigente = rec.get('esVigente');
		var esPropuesta = rec.get('esPropuesta');		
		var esPropuestaSuperusuario = rec.get('esPropuestaSuperusuario');		
		
		//Si está vigente y es gestor de objetivos o, está propuesta y es gestor / supervisor del expediente
		if ((esVigente && esGestorObjetivos) 
			|| (esPropuesta && (esGestorExpediente || esSupervisorExpediente)) 
			|| (esPropuestaSuperusuario && isSuperusuario))
			btnNuevo.enable();
		else 
			btnNuevo.disable();
	});

//----------------------------------------------------------------------
// Paneles de datos
//----------------------------------------------------------------------


    var estadoPolitica = Ext.data.Record.create([
        {name : 'id'}
        ,{name : 'estado'}
        ,{name : 'fecha'}
        ,{name : 'gestor'}
        ,{name : 'usuario'}        
        ,{name : 'supervisor'}
        ,{name : 'politica'}
        ,{name : 'vigente'}
        ,{name : 'propuesta'}
    ]);

    estadoPoliticaStore = page.getStore({
        event:'listado'
        ,flow : 'politica/listadoEstadosPolitica'
        ,reader : new Ext.data.JsonReader(
            {root:'estadosPolitica'}
            , estadoPolitica
        )       
    });

    pPrePolitica = crearPanelEstado(btnPrePolitica);
    pCEPolitica = crearPanelEstado(btnCEPolitica);
    pREPolitica = crearPanelEstado(btnREPolitica);
    pDCPolitica = crearPanelEstado(btnDCPolitica);
    pVigentePolitica = crearPanelEstado(btnVigPolitica);
    
//----------------------------------------------------------------------
// Paneles
//----------------------------------------------------------------------


    var panelPolitica = new Ext.Panel({
        title : '<s:message code="politica.datosPolitica" text="**Datos de una política" />'
        ,layout:'table'
        ,layoutConfig : {
            columns:6
        }
        ,style: 'padding-bottom:10px;'
        ,defaults : {border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding-bottom:5px;padding-top:5px;padding:10px;cellspacing:10px'}
        ,items:[crearPanelLabels(),pPrePolitica,pCEPolitica,pREPolitica,pDCPolitica,pVigentePolitica]
    });

    return panelPolitica;
};


	

    var crearPanelLabels = function(boton){
        var pLabels = new Ext.Panel({
            height:80
            ,items:[
                new Ext.ux.form.StaticTextField({
                    hideLabel:true
                    ,height:20
                    ,style:'font-weight:bolder'
                    ,value:''
                }),
                new Ext.ux.form.StaticTextField({
                    hideLabel:true
                    ,height:20
                    ,style:'font-weight:bolder'
                    ,value:'<s:message code="politica.fecha" text="**Fecha" />'
                })
                <%--,
                new Ext.ux.form.StaticTextField({
                    hideLabel:true
                    ,height:20
                    ,style:'font-weight:bolder'
                    ,value:'<s:message code="politica.politica" text="**Política" />'
                }) --%>
                 ]
    });

    return pLabels;
}

var crearPanelEstado = function(boton){
    var fecha = new Ext.ux.form.StaticTextField({
        name:'fecha'
        ,hideLabel:true
        ,height:20
    });
    
    var politica = new Ext.ux.form.StaticTextField({
        name:'politica'
        ,height:20 
        ,hideLabel:true        
    });

    var usuario = new Ext.form.Hidden({name: 'usuario'});
    var gestor = new Ext.form.Hidden({name: 'gestor'});
    var supervisor = new Ext.form.Hidden({name: 'superior'});
    var id = new Ext.form.Hidden({name: 'id'});
    var editable = new Ext.form.Hidden({name: 'editable'});
    var propuesta = new Ext.form.Hidden({name: 'propuesta'});



    var pEstado = new Ext.form.FormPanel({
       height:80
       ,items:[boton,fecha,usuario,gestor,supervisor,politica,id,editable,propuesta]
       ,cls:'bordeInactivo'
    });

    return pEstado;
}

//----------------------------------------------------------------------
// Funciones para recargar datos
//----------------------------------------------------------------------

var reloadEstados = function(idCicloMarcadoPolitica) {
    objetivosStore.removeAll();
    //objetivosStore.webflow({idEstado:0});
    page.webflow({
      flow: 'politica/listadoEstadosPolitica', 
      params: {idCicloMarcadoPolitica: idCicloMarcadoPolitica},
      success: function(data, config) {
          setearDatos(data);
      }
    });
};

var setearDatos = function(data) {
    limpiarPanel(pPrePolitica);
    limpiarPanel(pCEPolitica);
    limpiarPanel(pREPolitica);
    limpiarPanel(pDCPolitica);
    limpiarPanel(pVigentePolitica); 
    
    var estadoPrepolitica = '<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_PREPOLITICA" />';
    var estadoCE = '<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_COMPLETAR_EXPEDIENTE" />';
    var estadoRE = '<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_REVISAR_EXPEDIENTE" />';
    var estadoDC = '<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_DECISION_COMITE" />';
    var estadoVigente = '<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_VIGENTE" />';

	var panelActivo = null;
	
    for (var i=0; i < data.politicas.length; i++)
    {
    	var politica = data.politicas[i];

		//Seleccionamos un panel para cargar datos
		var panel = null;
		
		if (politica.estado == estadoPrepolitica)
		{
			panel = pPrePolitica;
		}
		else if (politica.estado == estadoCE)
		{
			panel = pCEPolitica;
		}    	
		else if (politica.estado == estadoRE) 
		{
			panel = pREPolitica;    	
		}
		else if (politica.estado == estadoDC) 
		{
			panel = pDCPolitica;    	
		}
		else if (politica.estado == estadoVigente) 
		{
			panel = pVigentePolitica;    	
		}
		
		setearPanel(panel, politica);
		
		if (politica.fecha != null && politica.fecha != '')
		{
			panelActivo = panel;
		}
    }
    
    if (panelActivo != null)
    {
    	cargarObjetivos(panelActivo);
    }
};

var setearPanel = function(panel, datos) {
    if(datos == null) return;
    panel.items.items[1].setValue(datos.fecha);
    panel.items.items[2].setValue(datos.usuario);
    panel.items.items[3].setValue(datos.gestor);
    panel.items.items[4].setValue(datos.supervisor);
    panel.items.items[5].setValue(datos.politica);
    panel.items.items[6].setValue(datos.id);
    panel.items.items[7].setValue(datos.vigente);
    panel.items.items[8].setValue(datos.propuesta);
    
	var mensajeTooltip = '<b>Usuario: </b>'+datos.usuario+'</br>';
	mensajeTooltip += '<b>Gestor: </b>'+datos.gestor+'</br>';
	mensajeTooltip += '<b>Supervisor: </b>'+datos.supervisor+'</br>';
	panel.items.items[0].setTooltip(mensajeTooltip);
}

var limpiarPanel = function(panel) {
    panel.items.items[0].setTooltip('');
    panel.items.items[1].setValue('');
    panel.items.items[2].setValue('');
    panel.items.items[3].setValue('');
    panel.items.items[4].setValue('');
    panel.items.items[5].setValue('');
    panel.items.items[6].setValue('');
    panel.items.items[7].setValue('');
    panel.items.items[8].setValue('');
}