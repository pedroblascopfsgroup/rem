<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

		var openPanel = function( flow, params, config){
			var url = '/${appProperties.appName}/'+flow+'.htm';
			config = config || {};
			//si existe, lo mostraremos
			//TODO: controlar en el callback en caso de que tengamos un error
			var autoLoad = {url : url+"?"+Math.random()
					,scripts: true
					,method : 'POST'
					,callback : function(scope, success, response, options){}
					};
			if (params){
				autoLoad.params = params;
			}
			//si existe el tab, borraremos el contenido y recargamos
			if (config.id){
				var control = Ext.getCmp(config.id);
				if (control){
					var id =control.el.child('.x-panel').id;
		            Ext.getCmp(config.id).remove(id,true);
					Ext.getCmp(config.id).load(autoLoad);
					control.show();
					return false;
				}
			}
			var cfg = {
				layout : 'fit'
				,autoScroll : true
				,autoHeight : true
				,iconCls: config.iconCls || ''
				//,autoWidth  : true
				,autoLoad : autoLoad
			};
			if (config.id) cfg.id=config.id;
			wizardPanel.add(cfg).show();
			return true;
		};
	//Step 1
	var panel1=new Ext.Panel({
		id:'panel1'
		,autoHeight:true
		,autoLoad:{	
			//url: app.resolveFlow('fase2/altaProcedimiento')
			url: app.resolveFlow('expedientes/listadoContratos')
			,method : 'POST'
			,scripts : true
			,params :  {}
		}
		//,hidden:true
	});
	var panel2=new Ext.Panel({
		id:'card-1'
		,autoHeight:true

	});
	var panel3=new Ext.Panel({
		html:'<br><br>PANEL 3'
		,id:'card-2'
	});
	var currentPanel = 0;
	var cardNav = function(incr){

		currentPanel += incr;
		        
        if (currentPanel > 2) {
            currentPanel = 2;
        }
        if (currentPanel < 0) {
            currentPanel = 0;
        }
		var panelActual;
		fwk.log(currentPanel)
		if(currentPanel==0){
			fwk.log('panel 0')
			//panel1.load({
			//	url:app.resolveFlow('expedientes/listadoContratos')
			//	,params:{idPersona:'1'}
			//	,method : 'POST'
			//	,text:'Cargando 2 step...'
			//	,scripts:true
			//});
		}
        if(currentPanel==1){
			fwk.log('panel 1');
			
			openPanel('clientes/bienes',{idPersona:'1'},{});
			
		}
		if(currentPanel==2){
			fwk.log('panel 2')
			//panel1.load({
			//	url:app.resolveFlow('clientes/bienes')
			//	,params:{idPersona:'1'}
			//	,method : 'POST'
			//	,text:'Cargando 2 step...'
			//	,scripts:true
			//});
		}	
		
		//wizardPanel.getLayout().setActiveItem(panel2);
		Ext.getCmp('card-prev').setDisabled(currentPanel==0);
		Ext.getCmp('card-next').setDisabled(currentPanel==2);
		btnGuardar.setDisabled(currentPanel!=2);
		wizardPanel.doLayout();
	};
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,disabled:true
		,handler : function() {
			page.submit({
				eventName : 'update'
				,formPanel : wizardPanel
				,success : function(){ page.fireEvent(app.event.DONE); }
			});
	   }
	});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.submit({
				eventName : 'cancel'
				,formPanel : wizardPanel
				,success : function(){ page.fireEvent(app.event.CANCEL); } 	
			});
		}
	});
	var wizardPanel=new Ext.Panel({
		layout:'card'
	    ,activeItem: 0 // make sure the active item is set on the container config!
	    ,autoHeight:true
	    ,bodyStyle: 'padding:15px'
		,layoutConfig: {
			deferredRender: true
			//, renderHidden: true
		}
	    ,defaults: {
	        // applied to each contained panel
	        border:false
	    }
	    // the panels (or "cards") within the layout
		
	    // just an example of one possible navigation scheme, using buttons
	    ,tbar: [
			btnGuardar
			,btnCancelar
			,'->' // greedy spacer so that the buttons are aligned to each side
	        ,{
	            id: 'card-prev',
	            text: 'Anterior',
	            handler: cardNav.(this, [-1]),
	            disabled: true
	        },{
	            id: 'card-next',
	            text: 'Siguiente',
	            handler: cardNav.createDelegate(this, [1])
	        }
	    ]
	
	});
	page.add(wizardPanel)
</fwk:page>