Ext.define('HreRem.view.configuracion.mediadores.detalle.CarteraMediadorStats', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'carteramediadorstats',
    reference: 'carteraMediadorStats',
	topBar: false,
	idPrincipal : 'id',
	editOnSelect: false,
	disabledDeleteBtn: true,
	
    bind: {
        store: '{listaStatsCarteraMediadores}'
    },
    
    
    initComponent: function () {
     	var me = this;
		
     	var esTopRenderer =  function(value) {
        	
        	var src = '',
        	alt = '';
        	
        	if (value == 1) {
        		src = 'ico_favorito_added.svg';
        		alt = 'OK';
        	} else { 
        		src = 'ico_favorito_off.png';
        		alt = 'KO';
        	} 

        	if (src != '') {
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="18px"></div>';
        	} else {
        		return null;
        	}
        }; 

     	var medalRenderer =  function(value) {
        	
        	var src = '';

			if (value != undefined) {
	        	if (value == 'Platino') {
	        		src = 'ico_medal_platinum.png';
	        		alt = 'OK';
	        	} else if (value == 'Oro') { 
	        		src = 'ico_medal_gold2.png';
	        		alt = 'OK';
	        	} else if (value == 'Plata') { 
	        		src = 'ico_medal_silver.png';
	        		alt = 'OK';
	        	} else if (value == 'Bronce') { 
	        		src = 'ico_medal_bronze.png';
	        		alt = 'OK';
	        	} else if (value.substr(0,7) == 'Retirar') { 
	        		src = 'ico_medal_remove.png';
	        		alt = 'OK';
	        	}

	        }
	        	        	
        	if (src != '') {
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="18px"></div>';
        	} else {
        		return null;
        	}
 
        };

		me.columns = [
				{
					dataIndex: 'id',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.id'),
					flex: 0.3,
					hidden: true
				},
				{
					dataIndex: 'numActivos',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numActivos'),
					flex: 0.3
				},
				{
					dataIndex: 'numVisitas',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numVisitas'),
					flex: 0.3
				},
				{
					dataIndex: 'numOfertas',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numOfertas'),
					flex: 0.3
				},
				{
					dataIndex: 'numReservas',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numReservas'),
					flex: 0.5
				},
				{
					dataIndex: 'numVentas',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numVentas'),
					flex: 0.3
				},
				{
					dataIndex: 'descripcionCalificacion',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.Calificacion'),
					renderer: medalRenderer,
					flex: 1
				},
				{
					dataIndex: 'esTop',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.esTop'),
					renderer: esTopRenderer,
					flex: 1
				}		
		    ];
		    
		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{listaStatsCarteraMediadores}'
		            }
		        }
		    ];
		    
		    me.callParent();
   }

});