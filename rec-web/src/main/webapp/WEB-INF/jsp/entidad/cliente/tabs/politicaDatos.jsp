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
var panelEstado = [];

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
   if (this!=window){
      panel = this.ownerCt; // handler del boton, panel==undefined 
   }
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

   boton = function(politica, text, id){
      return new Ext.Button({
        text : text
        ,iconCls : 'icon_pendientes'
        ,height:20
        ,id:id
        ,handler:cargarObjetivos
      });
   }


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
        ,storeId : 'politicaPermisosStore'
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
        ,storeId : 'politicaEstadoStore'
        ,reader : new Ext.data.JsonReader(
            {root:'estadosPolitica'}
            , estadoPolitica
        )       
    });

    
//----------------------------------------------------------------------
// Paneles
//----------------------------------------------------------------------


    var panelPolitica = new Ext.Panel({
        title : '<s:message code="politica.datosPolitica" text="**Datos de una política" />'
        ,layout:{
        	type:'table'
        }
        ,id:'datosPlanActuacion'
        ,style: 'padding-bottom:10px;'
        ,defaults : {border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding-bottom:5px;padding-top:5px;padding:10px;cellspacing:10px'}
        ,items:[]
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
                })<%--,
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

var reloadEstados = function(idCicloMarcadoPolitica, idExpediente, panel) {

	var posicionPanel = panel.items.indexOfKey('datosPlanActuacion');

	if(idExpediente != null && idExpediente != ''){
	
		///Obtenemos los estados del itinerario
	  	Ext.Ajax.request({
			url : page.resolveUrl('mejexpediente/getItinerarioDelExpediente'), 
			params : {idExpediente: idExpediente},
			method: 'POST',
			success: function ( result, request ) {
	
				panel.items.get(posicionPanel).getEl().mask();
	
				panel.items.get(posicionPanel).removeAll( true );
			
				var resultado = Ext.decode(result.responseText);
				
				panel.items.get(posicionPanel).add(crearPanelLabels());
				
				var politicaInicial;
				var btnIni = boton(politicaInicial,'<s:message code="politica.boton.prePolitica" text="**Prepolitica" />','btnInicial' );
				politicaIni = crearPanelEstado(btnIni);
				panel.items.get(posicionPanel).add(politicaIni);
				panelEstado['<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_PREPOLITICA" />'] = politicaIni;
				
				for(i=0; i < resultado.estadosItinerario.length; i++){
	
					var fase = resultado.estadosItinerario[i];
					
					if(fase.codigo != '<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_PERIODO_CARENCIA" />' && fase.codigo != '<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_GESTION_VENCIDOS" />'){
						var politica;
						btn = boton(politica,fase.estadoItinerario,'btn'+fase.codigo );
							
						politica = crearPanelEstado(btn);
						panel.items.get(posicionPanel).add(politica);
						panelEstado[fase.codigo] = politica;
					}
					
				}
				
				var politicaFinal;
				var btnFin = boton(politicaFinal,'<s:message code="politica.boton.vigente" text="**Vigente" />','btnFinal' );
				politicaFin = crearPanelEstado(btnFin);
				panel.items.get(posicionPanel).add(politicaFin);
				panelEstado['<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_VIGENTE" />'] = politicaFin;
				
				panel.doLayout();
				 objetivosStore.removeAll();
    
			    page.webflow({
			      flow: 'politica/listadoEstadosPolitica', 
			      params: {idCicloMarcadoPolitica: idCicloMarcadoPolitica},
			      success: function(data, config) {
			          setearDatos(data);
			          panel.items.get(posicionPanel).getEl().unmask();
			      }
			    });
			}
		});
	
	}else{
				
				panel.items.get(posicionPanel).getEl().mask();
	
				panel.items.get(posicionPanel).removeAll( true );
	
				panel.items.get(posicionPanel).add(crearPanelLabels());
		
				var politicaInicial;
				var btnIni = boton(politicaInicial,'<s:message code="politica.boton.prePolitica" text="**Prepolitica" />','btnInicial' );
				politicaIni = crearPanelEstado(btnIni);
				panel.items.get(posicionPanel).add(politicaIni);
				panelEstado['<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_PREPOLITICA" />'] = politicaIni;
				
				var politicaCE;
				var btnCE = boton(politicaCE,'<s:message code="politica.boton.cePolitica" text="**CE Politica" />','btnCE' );
				politicaCE = crearPanelEstado(btnCE);
				panel.items.get(posicionPanel).add(politicaCE);
				panelEstado['<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_COMPLETAR_EXPEDIENTE" />'] = politicaCE;
				
				var politicaRE;
				var btnRE = boton(politicaRE,'<s:message code="politica.boton.rePolitica" text="**RE Politica" />','btnRE' );
				politicaRE = crearPanelEstado(btnRE);
				panel.items.get(posicionPanel).add(politicaRE);
				panelEstado['<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_REVISAR_EXPEDIENTE" />'] = politicaRE;
				
				var politicaDC;
				var btnDC = boton(politicaDC,'<s:message code="politica.boton.dcPolitica" text="**DC Politica" />','btnDC' );
				politicaDC = crearPanelEstado(btnDC);
				panel.items.get(posicionPanel).add(politicaDC);
				panelEstado['<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_DECISION_COMITE" />'] = politicaDC;
				
				var politicaFinal;
				var btnFin = boton(politicaFinal,'<s:message code="politica.boton.vigente" text="**Vigente" />','btnFinal' );
				politicaFin = crearPanelEstado(btnFin);
				panel.items.get(posicionPanel).add(politicaFin);
				panelEstado['<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_VIGENTE" />'] = politicaFin;
				
				panel.doLayout();
				 objetivosStore.removeAll();
    
			    page.webflow({
			      flow: 'politica/listadoEstadosPolitica', 
			      params: {idCicloMarcadoPolitica: idCicloMarcadoPolitica},
			      success: function(data, config) {
			          setearDatos(data);
			          panel.items.get(posicionPanel).getEl().unmask();
			      }
			    });
	}

};

var setearDatos = function(data) {
    
    <%-- Limpiamos todos los panels --%>
    for(p=0; p < panelEstado.length; p++){
    	limpiarPanel(panelEstado[p]);
    }
    
	var panelActivo = null;
	var ordenEstPol = 0;
	
    for (var i=0; i < data.politicas.length; i++)
    {
    	var politica = data.politicas[i];

		//Seleccionamos un panel para cargar datos
		var panel = null;
     
      	panel = panelEstado[politica.estado];
		
		setearPanel(panel, politica);
		
		if (politica.orden > ordenEstPol)
		{
			panelActivo = panel;
			ordenEstPol = politica.orden;
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

var limpiarPanel = function(panel) {}




