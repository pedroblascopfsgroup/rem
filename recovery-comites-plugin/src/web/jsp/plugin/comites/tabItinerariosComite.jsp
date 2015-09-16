<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<pfslayout:tabpage titleKey="plugin.comites.tabItinerarios.titulo" title="**Itinerarios compatibles" 
	items="gridItinerarios" >
	
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
            } 
        }, 
        renderer : function(v, p, record){ 
            p.css += ' x-grid3-check-col-td';  
            return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>'; 
        } 
    };
    
	
	<pfs:defineParameters name="parametros" paramId="${comite.id}" />
	
	<pfs:buttonedit name="btModificarItinerarios" 
			flow="plugin/comites/plugin.comites.modificarItinerarios" 
			parameters="parametros" 
			windowTitle="**Modificar itinerarios" 
			windowTitleKey="plugin.comites.tabItinerarios.modificarItinerarios"
			store_ref="itinerariosDS"
			/>
	
	<pfs:defineRecordType name="ItinerariosRT">
		<pfs:defineTextColumn name="idComite"/>
		<pfs:defineTextColumn name="idItinerario"/>
		<pfs:defineTextColumn name="itinerario"/>
		<pfs:defineTextColumn name="tipoItinerario"/>
		,{name : 'compatible', type:'bool'}	
	</pfs:defineRecordType>
	
	
	<pfs:remoteStore name="itinerariosDS" 
		resultRootVar="dtoItinerario" 
		recordType="ItinerariosRT" 
		dataFlow="plugin.comites.itinerariosComiteData"
		parameters="parametros"
		autoload="true"/>
		
	var compatible_edit = new Ext.grid.CheckColumn({ 
            header: '<s:message code="plugin.comites.tabItinerarios.compatible" text="**Compatible" />',  
            dataIndex: 'compatible',  
            width: 40,  
            sortable: true 
        });
		
	<pfs:defineColumnModel name="itinerariosCM">
		<pfs:defineHeader caption="**Itinerario" captionKey="plugin.comites.tabItinerarios.itinerario" 
			sortable="false" dataIndex="itinerario" firstHeader="true"/>
		<pfs:defineHeader caption="**Tipo de itinerario" captionKey="plugin.comites.tabItinerarios.tipo" 
			sortable="false" dataIndex="tipoItinerario" />
		,compatible_edit
	</pfs:defineColumnModel>
	Ext.util.CSS.createStyleSheet(".icon_itinerario { background-image: url('../img/plugin/comites/direction-arrow.png');}");
	
	
	<pfs:grid name="gridItinerarios"
		dataStore="itinerariosDS" 
		columnModel="itinerariosCM" 
		title="**Itinerarios compatibles con el comité" 
		collapsible="false" 
		titleKey="plugin.comites.tabItinerarios.titulo"
		bbar="btModificarItinerarios"
		iconCls="icon_itinerario"/>
	btModificarItinerarios.hide();
	<sec:authorize ifAllGranted="ROLE_EDIT_COM_ITI">
		btModificarItinerarios.show();
	</sec:authorize>
	
	</pfslayout:tabpage>
	

	