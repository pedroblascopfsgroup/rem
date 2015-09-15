<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	
	Ext.grid.CheckColumn = function(config){ 
        Ext.apply(this, config); 
        if(!this.id){ 
            this.id = Ext.id(); 
        } 
        this.renderer = this.renderer.createDelegate(this); 
    }; 
    Ext.grid.CheckColumn.prototype = { 
        init : function(grid){ 
            this.grid = grid; 
            this.grid.on('render', function(){ 
                var view = this.grid.getView(); 
                view.mainBody.on('mousedown', this.onMouseDown, this); 
            }, this); 
        }, 
        onMouseDown : function(e, t){ 
            if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){ 
                e.stopEvent(); 
                var index = this.grid.getView().findRowIndex(t); 
                var record = this.grid.store.getAt(index); 
                var value = !record.data[this.dataIndex];
                record.set(this.dataIndex, value); 
                this.grid.modifiedData['dtoItinerario['+index	+'].'+this.dataIndex]=value;
            } 
        }, 
        renderer : function(v, p, record){ 
            p.css += ' x-grid3-check-col-td';  
            return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>'; 
        } 
    };
    
   
	
	<pfs:defineParameters name="parametros" paramId="${comite.id}" />
	
	<pfs:defineRecordType name="ItinerariosRT">
		<pfs:defineTextColumn name="idComite"/>
		<pfs:defineTextColumn name="idItinerario"/>
		<pfs:defineTextColumn name="itinerario"/>
		<pfs:defineTextColumn name="tipoItinerario"/>
		,{name : 'compatible', type:'bool'}
	</pfs:defineRecordType>
	
	var itinerariosDS = page.getStore({
		eventName : 'getData'
		,flow : 'plugin/comites/plugin.comites.modificarItinerarios' 
		,reader: new Ext.data.JsonReader({
    		root : 'dtoItinerario'
   	 	}, ItinerariosRT)
	});
	
	itinerariosDS.webflow();

	var btnGuardar = new Ext.Button({
	text : '<s:message code="plugin.comites.editarItinerarios.guardar" text="**Guardar" />'
	,iconCls:'icon_ok'
	,handler : function(){
		Ext.Msg.confirm('<s:message code="plugin.comites.editarItinerarios.guardar" text="**Guardar" />','<s:message code="plugin.comites.editarItinerarios.seguro" text="**¿Seguro que desea guardar?" />',this.decide,this);
		}
	,decide : function(boton){
			if (boton=='yes'){
				this.guardar();
			}
		}
	,guardar : function(){
			page.webflow({
				flow : 'plugin/comites/plugin.comites.modificarItinerarios' 
				,eventName : 'update'
				,success : function(){ page.fireEvent(app.event.DONE); }
				,params : grid.modifiedData
			});
		}
	});
	
	
	var btnCancelar = new Ext.Button({
	text : '<s:message code="plugin.comites.editarItinerarios.cancelar" text="**Cancelar" />'
	,iconCls:'icon_cancel'
	,handler : function(){
		Ext.Msg.confirm('<s:message code="plugin.comites.editarItinerarios.cancelar" text="**Cancelar" />','<s:message code="plugin.comites.editarItinerarios.seguroCancelar" text="**¿Seguro que desea descartar los cambios?" />',this.decide,this);
		//this.cancelar();
		}
	,decide : function(boton){
			if (boton=='yes'){
				this.cancelar();
			}
		}
	,cancelar : function(){
			page.webflow({
				flow : 'plugin/comites/plugin.comites.modificarItinerarios' 
				,eventName : 'fin1'
				,success : function(){ page.fireEvent(app.event.CANCEL); }
			});
		}
	});
	 <%--
	<pfsforms:check labelKey="" label="" name="compatible_edit" value=""/>
	
	var compatible_edit = new Ext.grid.CheckColumn({
       header: '<s:message code="plugin.comites.tabItinerarios.compatible" text="**Compatible" />',
       dataIndex: 'compatible',
       width: 55
    });
    
    var ce = {
    	header: '<s:message code="plugin.comites.tabItinerarios.compatible" text="**Compatible" />'
    	,dataIndex: 'compatible'
        ,width: 55
    };
    
    var compatible_edit = Ext.grid.CheckColumn(ce);--%>
	
	 var compatible_edit = new Ext.grid.CheckColumn({ 
            header: '<s:message code="plugin.comites.tabItinerarios.compatible" text="**Compatible" />',  
            dataIndex: 'compatible',  
            width: 70,  
            sortable: true 
        }); 
	
	var grid = new Ext.grid.EditorGridPanel({
		title: '<s:message code="plugin.comites.editarItinerarios.titulo" text="**Itinerarios compatibles con el comité" arguments="${comite.nombre}"/>',
		stripeRows: true,
		resizable:true, 
		autoHeight: true,
		cls:'cursor_pointer',
		clickstoEdit: 1,
		plugins: compatible_edit,
		store: itinerariosDS,
		columns: [
			{header: '<s:message code="plugin.comites.tabItinerarios.itinerario" text="**Itinerarios" />', dataIndex: 'itinerario', width:200},
			{header: '<s:message code="plugin.comites.tabItinerarios.tipo" text="**Tipo de itinerario" />', dataIndex: 'tipoItinerario',width:200},
			compatible_edit 
		],
		bbar: [
		btnGuardar,btnCancelar 
		]	
	});
	
	grid.modifiedData={};
	grid.on('afteredit', function(editEvent){
			alert(editEvent.field);
			grid.modifiedData['dtoItinerario['+editEvent.row+'].'+editEvent.field]=editEvent.value;
		});
	


	page.add(grid);

</fwk:page>