<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

Ext.ns('Ext.pfs.metaform');

Ext.ns('Ext.ux.util');

/**
 * Clone Function
 * @param {Object/Array} o Object or array to clone
 * @return {Object/Array} Deep clone of an object or an array
 * @author Ing. Jozef Sakáloš
 */
Ext.ux.util.clone = function(o) {
    if(!o || 'object' !== typeof o) {
        return o;
    }
    if('function' === typeof o.clone) {
        return o.clone();
    }
    var c = '[object Array]' === Object.prototype.toString.call(o) ? [] : {};
    var p, v;
    for(p in o) {
        if(o.hasOwnProperty(p)) {
            v = o[p];
            if(v && 'object' === typeof v) {
                c[p] = Ext.ux.util.clone(v);
            }
            else {
                c[p] = v;
            }
        }
    }
    return c;
}; // eo function clone 

<%--CONTROLES --%>
Ext.pfs.metaform.DDCombo = Ext.extend(Ext.form.ComboBox,{
	displayField: 'descripcion'
	,mode: 'local'
	,valueField: 'codigo'
	,triggerAction: 'all'
	,emptyText: '---'
	,validationEvent : 'change'
	,resizable : true
	,required: true
	,forceSelection:true
	,editable: true
	//,data: 
	,initComponent:function() {
		this.store = new Ext.data.JsonStore({
			fields : ['codigo', 'descripcion']
			,root: 'diccionario'
		});
		this.store.loadData({diccionario:this.data});
		this.hiddenName = this.name;
		//alert(this.store.data);
		//alert(this.store.data.diccionario[0].descripcion);
	}
});
Ext.reg('ddcombo', Ext.pfs.metaform.DDCombo);

Ext.pfs.metaform.CurrencyField = Ext.extend(Ext.form.NumberField,{
	maxValue: 9999999999999999
	//,autoCreate: {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
	,initComponent:function() {
		this.hiddenName = this.name;
	}
});
Ext.reg('currencyfield', Ext.pfs.metaform.CurrencyField);
<%--fin de CONTROLES --%>

<%-- CONTROLES READ-ONLY --%>
Ext.pfs.metaform.GenericReadOnlyField = Ext.extend(Ext.ux.form.StaticTextField,{
	initComponent : function(){
		this.labelStyle = 'font-weight:bolder';
	}
});

Ext.pfs.metaform.GenericReadOnlyCombo = Ext.extend(Ext.ux.form.StaticTextField,{
	initComponent : function(){
		this.labelStyle = 'font-weight:bolder';
	}
	,onRender : function(ct, position){
        Ext.ux.form.StaticTextField.superclass.onRender.call(this, ct, position);
		var store = new Ext.data.JsonStore({
			fields : ['codigo', 'descripcion']
			,root: 'diccionario'
		});
		store.loadData({diccionario:this.data});
		var i = store.find('codigo',this.getValue());
		var r = store.getAt(i);
		this.setValue(r.get('descripcion'));
	}
});

Ext.reg('currencyfieldRO', Ext.pfs.metaform.GenericReadOnlyField);
Ext.reg('textareaRO', Ext.pfs.metaform.GenericReadOnlyField);
Ext.reg('ddcomboRO', Ext.pfs.metaform.GenericReadOnlyCombo);
Ext.reg('datefieldRO', Ext.pfs.metaform.GenericReadOnlyField);
Ext.reg('numberfieldRO', Ext.pfs.metaform.GenericReadOnlyField);
Ext.reg('textRO', Ext.pfs.metaform.GenericReadOnlyField);

<%--fin de CONTROLES READ-ONLY --%>

Ext.pfs.metaform.ButtonFactory = {
	createButtons: function(win){
		if (win.readOnly == "true"){
			return this.readOnlyButtons;
		}else{
			return this.defaultButtons;
		}
	}
	,defaultButtons : [
            				{
            					text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
            					,iconCls : 'icon_ok'
            					,handler:function() {
            						var na = Ext.getCmp('metaform-win').items.get(0).getForm().nextAction;
            						Ext.getCmp('metaform-win').items.get(0).getForm().baseParams.<fwk:const value="es.pfsgroup.commons.utils.web.controller.metaform.MetaformController.PRM_NEXT_ACTION" /> = na;
                    				Ext.getCmp('metaform-win').items.get(0).getForm().submit({
                    					success: function(form,action){
                    						Ext.getCmp('metaform-win').items.get(0).getForm().process(form,action);
                    					}
                    					,failure : function(form,action){
                    						Ext.getCmp('metaform-win').items.get(0).getForm().process(form,action);
                    					}
                    				});
                				}
            				},{
            					text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
								,iconCls : 'icon_cancel'
								,handler : function(){ Ext.getCmp('metaform-win').fireEvent(app.event.CANCEL); }
            				}
            			]
     ,readOnlyButtons: [
     					{
            					text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
								,iconCls : 'icon_cancel'
								,handler : function(){ Ext.getCmp('metaform-win').fireEvent(app.event.CANCEL); }
            				}
     ]
};

Ext.pfs.metaform.openWindow = function(cfg){
				var alto = cfg.height || 300;
				var ancho = cfg.width || 700;
				var wX = cfg.x || 50;
				var wY = cfg.y || 50;
				var win = new Ext.Window({
        			 id:'metaform-win'
        			,layout:'fit'
        			,width:0
        			,height:0
        			,title: cfg.title || 'NO DEFINIDO'
        			,modal : true
        			,resizable : false
        			,autoShow : true
        			,bodyStyle:'background-color:#ffffff'
        			,readOnly: false
        			,items:{
             			xtype:'metaform'
            			,url: cfg.flow || 'NO_DEFINIDO'
            			,style: 'margin:10px'
						,bodyStyle:'background-color:#ffffff'
            			,nextAction: cfg.nextAction || 'mfUNDEFINED'
            			,baseParams : Ext.ux.util.clone(cfg.params || {})
            			,process : function (form,action){
            				if (action.result){
                    			if  (action.result.success){
									Ext.getCmp('metaform-win').fireEvent(app.event.DONE);
                    			}else{
                    				Ext.Msg.minWidth = 400;
                  					Ext.MessageBox.alert('<s:message code="pfs.commons.metaform.error.title.save" text="**Error al guardar" />'
               								, action.result.fwk.fwkExceptions);
	                  			}
                    		}
                    	}
            			,afterMetaChange : function(){
            					var h = this.windowHeight;
            					var w = this.windowWidth;
            					if (h == 0) h = alto;
            					if (w == 0) w = ancho;
            					win.setHeight(h);
    							win.setWidth(w);
    							win.setPosition(wX, wY);
    							if (this.windowTitle){
    								win.setTitle(this.windowTitle);
    							}
    							win.putReadOnlyMode(this.readOnly);
        				}
        			}
        			,putReadOnlyMode : function(ro){
        				this.readOnly = ro;
        				<%--//this.getBottomToolbar().removeAll();
        				this.getBottomToolbar().add(Ext.pfs.metaform.ButtonFactory.createButtons(this));
        				this.getBottomToolbar().syncSize();
        				 --%>
        				this.getBottomToolbar().add(Ext.pfs.metaform.ButtonFactory.createButtons(this));
        			}
        			,bbar:[]
        			
    			});
    			win.show();
    			win.on(app.event.DONE,function(){
    				win.close();
    				if (cfg.onsuccess) cfg.onsuccess();
    			});
    			win.on(app.event.CANCEL,function(){
    				win.close();
    			});
};

Ext.pfs.metaform.Button = Ext.extend(Ext.Button, {
	windowTitle : 'windowTitle: NO DEFINIDO'
	,flow : 'flow_NO_DEFINIDO'
	,nextAction: 'nextAction: NO DEFINIDO'
	,params: {}
	,onsuccess : function(){}
	,setParams : function (p){
		this.params = p;
	}
	,handler : function(){
				var altura = 300;
				var p = this.params || {};
				p.mfid = this.mfid;
				Ext.pfs.metaform.openWindow({
					title: this.windowTitle
					,flow: this.flow
					,width: this.windowWidth
					,height: this.windowHeight
					,nextAction: this.nextAction
					,mfid: this.mfid
					,params: p
					,onsuccess: this.onsuccess
				});
				
	}
});

Ext.pfs.metaform.editHandler = function (config){
	var p = config.params;
	var onsuccess = Ext.emptyFn;
	p.mfNextAction = '<fwk:const value="es.pfsgroup.commons.utils.web.controller.metaform.MetaformController.ACTION_GET" />';
	p.mfid = config.mfid;
	if (config.store && config.store.cmp){
			var store = config.store.cmp;
			if (config.store.params){
				var params = config.store.params; 
				onsuccess = function(){ 
					store.webflow(params);
				};
			}else{
				onsuccess = function(){
					store.webflow();
				};
			}
		}
	
	Ext.pfs.metaform.openWindow({
		title: config.windowTitle
		,flow: config.flow
		,nextAction: '<fwk:const value="es.pfsgroup.commons.utils.web.controller.metaform.MetaformController.ACTION_UPDATE" />'
		,mfid: config.mfid
		,params: p
		,onsuccess: onsuccess
	});
};

Ext.pfs.metaform.AgregarButton = Ext.extend(Ext.pfs.metaform.Button, {
	text : '<s:message code="pfs.tags.buttonadd.agregar" text="**Agregar" />'
	,iconCls : 'icon_mas'
	,nextAction: '<fwk:const value="es.pfsgroup.commons.utils.web.controller.metaform.MetaformController.ACTION_CREATE" />'
	,caption: 'xx'
	,setStoreParams : function (p){
		this.store.cmp.getParams = function(){return p};
	}
	,initComponent : function(){
		var c1 = '<s:message code="pfs.tags.buttonadd.agregar" text="**Agregar" />';
		var c2 = this.caption;
		if (c2 != 'xx'){
			this.text = c2;
		}
		if (this.store && this.store.cmp){
			var store = this.store.cmp;
			if (this.store.params){
				this.onsuccess = function(){ 
					store.webflow(store.getParams());
				};
			}else{
				this.onsuccess = function(){
					store.webflow();
				};
			}
		}
	}
});

Ext.pfs.metaform.ModificarButton = Ext.extend(Ext.pfs.metaform.Button, {
	text : '<s:message code="pfs.tags.buttonedit.modificar" text="**Modificar" />'
	,iconCls : 'icon_edit'
	,nextAction: '<fwk:const value="es.pfsgroup.commons.utils.web.controller.metaform.MetaformController.ACTION_UPDATE" />'
	,caption: 'xx'
	,setParams : function(p){
		//alert(p);
		if (p!=null){
			p.mfNextAction = '<fwk:const value="es.pfsgroup.commons.utils.web.controller.metaform.MetaformController.ACTION_GET" />';
			this.params = p;
		}
	}
	,initComponent : function(){
		this.setParams(this.params);
		var c1 = '<s:message code="pfs.tags.buttonadd.agregar" text="**Agregar" />';
		var c2 = this.caption;
		if (c2 != 'xx'){
			this.text = c2;
		}
		if (this.store && this.store.cmp){
			var store = this.store.cmp;
			if (this.store.params){
				var params = this.store.params; 
				this.onsuccess = function(){ 
					store.webflow(params);
				};
			}else{
				this.onsuccess = function(){
					store.webflow();
				};
			}
		}
	}
});
