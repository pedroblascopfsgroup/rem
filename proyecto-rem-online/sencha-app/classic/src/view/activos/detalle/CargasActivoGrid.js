Ext.define('HreRem.view.activos.detalle.CargasActivoGrid', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'cargasactivogrid',
    reference	: 'cargasactivogrid',
    topBar		: true,
    bind : {
    	store : '{storeCargas}'
    },
    selModel : {
    	type : 'checkboxmodel'
    },

    initComponent: function () {

    	var me = this;

        me.columns = [
        		{
                    text : HreRem.i18n('header.origen.dato'),
                    dataIndex : 'origenDatoDescripcion',
                    flex : 1
                 }, {
                    text : HreRem.i18n('header.tipo.carga'),
                    dataIndex : 'tipoCargaDescripcion',
                    flex : 1
                 }, {
                    text : HreRem.i18n('header.subtipo.carga'),
                    flex : 1,
                    dataIndex : 'subtipoCargaDescripcion'
                 }, {
                	text : HreRem.i18n('header.estado.carga'),
                    flex : 1,
                    dataIndex : 'estadoDescripcion'
                 }, {
                    text : HreRem.i18n('header.subestado.carga'),
                    flex : 1,
                    dataIndex : 'subestadoDescripcion'
                 }, {
                    text : 'Estado carga econ&oacute;mica',
                    flex : 1,
                    dataIndex : 'estadoEconomicaDescripcion',
                    hidden:true,
                    disabled:true
                 }, {
                    text : HreRem.i18n('header.titular'),
                    flex : 1,
                    dataIndex : 'titular'
                 }, {
                    text : 'Importe registral',
                    dataIndex : 'importeRegistral',
                    renderer : function(value) {
                      return Ext.util.Format.currency(value);
                    },
                    flex : 1
                 }, {
                    text : 'Importe econ&oacute;mico',
                    dataIndex : 'importeEconomico',
                    renderer : function(value) {
                      return Ext.util.Format.currency(value);
                    },
                    flex : 1
                 }, {
                	text : HreRem.i18n('fieldlabel.con.cargas.propias'),
		        	dataIndex: 'cargasPropias',
		        	renderer : function(value) {
		        		if(value == "1"){
		        			return "Si";
		        		}else if(value == "0"){
		        			return "No";
		        		}else {
		        			return "";
		        		}
	                },
		        	flex: 1
				 },
				 {
	                text : HreRem.i18n('header.fecha.solicitud.carta.pago'),
	                dataIndex : 'fechaSolicitudCarta',
	                flex : 1,
		            formatter: 'date("d/m/Y")'
	              },
	              {
		            text : HreRem.i18n('header.fecha.recepcion.carta.pago'),
		            dataIndex : 'fechaRecepcionCarta',
		            flex : 1,
		            formatter: 'date("d/m/Y")'
		          },
		          {
			        text : HreRem.i18n('header.fecha.presentacion.carta.pago'),
			        dataIndex : 'fechaPresentacionRpCarta', 
			        flex : 1,
		            formatter: 'date("d/m/Y")'
			      }

        ];

        me.dockedItems = [
        	{
        		xtype : 'pagingtoolbar',
                dock : 'bottom',
                displayInfo : true,
                bind : {
                	store : '{storeCargas}'
                }
        	}
        ];

        me.listeners = {
        	afterrender : 'onRenderCargasList',
            rowdblclick : 'onCargasListDobleClick'
        };

        me.callParent();
    }

});