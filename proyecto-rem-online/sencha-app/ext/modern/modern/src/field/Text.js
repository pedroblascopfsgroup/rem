/**
 * The text field is the basis for most of the input fields. It provides a baseline of shared
 * functionality such as input validation, standard events, state management and look and feel. Typically we create
 * text fields inside a form, like this:
 *
 *     @example
 *     Ext.create('Ext.form.Panel', {
 *         fullscreen: true,
 *         items: [
 *             {
 *                 xtype: 'fieldset',
 *                 title: 'Enter your name',
 *                 items: [
 *                     {
 *                         xtype: 'textfield',
 *                         label: 'First Name',
 *                         name: 'firstName'
 *                     },
 *                     {
 *                         xtype: 'textfield',
 *                         label: 'Last Name',
 *                         name: 'lastName'
 *                     }
 *                 ]
 *             }
 *         ]
 *     });
 *
 * This creates two text fields inside a form. Text Fields can also be created outside of a Form, like this:
 *
 *     Ext.create('Ext.field.Text', {
 *         label: 'Your Name',
 *         value: 'Ed Spencer'
 *     });
 *
 * ## Configuring
 *
 * Text field offers several configuration options, including {@link #placeHolder}, {@link #maxLength},
 * {@link #autoComplete}, {@link #autoCapitalize} and {@link #autoCorrect}. For example, here is how we would configure
 * a text field to have a maximum length of 10 characters, with placeholder text that disappears when the field is
 * focused:
 *
 *     Ext.create('Ext.field.Text', {
 *         label: 'Username',
 *         maxLength: 10,
 *         placeHolder: 'Enter your username'
 *     });
 *
 * The autoComplete, autoCapitalize and autoCorrect configs simply set those attributes on the text field and allow the
 * native browser to provide those capabilities. For example, to enable auto complete and auto correct, simply
 * configure your text field like this:
 *
 *     Ext.create('Ext.field.Text', {
 *         label: 'Username',
 *         autoComplete: true,
 *         autoCorrect: true
 *     });
 *
 * These configurations will be picked up by the native browser, which will enable the options at the OS level.
 *
 * Text field inherits from {@link Ext.field.Field}, which is the base class for all fields and provides
 * a lot of shared functionality for all fields, including setting values, clearing and basic validation. See the
 * {@link Ext.field.Field} documentation to see how to leverage its capabilities.
 */
Ext.define('Ext.field.Text', {
    extend: 'Ext.field.Field',
    xtype: 'textfield',
    alternateClassName: 'Ext.form.Text',

    /**
     * @event focus
     * Fires when this field receives input focus
     * @param {Ext.field.Text} this This field
     * @param {Ext.event.Event} e
     */

    /**
     * @event blur
     * Fires when this field loses input focus
     * @param {Ext.field.Text} this This field
     * @param {Ext.event.Event} e
     */

    /**
     * @event paste
     * Fires when this field is pasted.
     * @param {Ext.field.Text} this This field
     * @param {Ext.event.Event} e
     */

    /**
     * @event mousedown
     * Fires when this field receives a mousedown
     * @param {Ext.field.Text} this This field
     * @param {Ext.event.Event} e
     */

    /**
     * @event keyup
     * @preventable doKeyUp
     * Fires when a key is released on the input element
     * @param {Ext.field.Text} this This field
     * @param {Ext.event.Event} e
     */

    /**
     * @event clearicontap
     * @preventable doClearIconTap
     * Fires when the clear icon is tapped
     * @param {Ext.field.Text} this This field
     * @param {Ext.field.Input} input The field's input component.
     * @param {Ext.event.Event} e
     */

    /**
     * @event change
     * Fires when the value has changed.
     * @param {Ext.field.Text} this This field
     * @param {String} newValue The new value
     * @param {String} oldValue The original value
     */

    /**
     * @event action
     * @preventable doAction
     * Fires whenever the return key or go is pressed. FormPanel listeners
     * for this event, and submits itself whenever it fires. Also note
     * that this event bubbles up to parent containers.
     * @param {Ext.field.Text} this This field
     * @param {Mixed} e The key event object
     */

    config: {
        /**
         * @cfg
         * @inheritdoc
         */
        ui: 'text',

        /**
         * @cfg
         * @inheritdoc
         */
        clearIcon: true,

        /**
         * @cfg {String} placeHolder A string value displayed in the input (if supported) when the control is empty.
         * @accessor
         */
        placeHolder: null,

        /**
         * @cfg {Number} maxLength The maximum number of permitted input characters.
         * @accessor
         */
        maxLength: null,

        /**
         * True to set the field's DOM element autocomplete attribute to "on", false to set to "off".
         * @cfg {Boolean} autoComplete
         * @accessor
         */
        autoComplete: null,

        /**
         * True to set the field's DOM element autocapitalize attribute to "on", false to set to "off".
         * @cfg {Boolean} autoCapitalize
         * @accessor
         */
        autoCapitalize: null,

        /**
         * True to set the field DOM element autocorrect attribute to "on", false to set to "off".
         * @cfg {Boolean} autoCorrect
         * @accessor
         */
        autoCorrect: null,

        /**
         * True to set the field DOM element readonly attribute to true.
         * @cfg {Boolean} readOnly
         * @accessor
         */
        readOnly: null,

        /**
         * @cfg {Object} component The inner component for this field, which defaults to an input text.
         * @accessor
         */
        component: {
            xtype: 'input',
            type: 'text',
            fastFocus: false
        },

        bubbleEvents: ['action']
    },

    defaultBindProperty: 'value',
    twoWayBindable: {
        value: 1
    },
    
    publishes: {
        value: 1
    },

    focusedCls: Ext.baseCSSPrefix + 'field-focused',
    clearableCls: Ext.baseCSSPrefix + 'field-clearable',
    emptyCls: Ext.baseCSSPrefix + 'empty',

    /**
     * @private
     */
    initialize: function() {
        var me = this;

        me.callParent();

        me.getComponent().on({
            scope: this,

            keyup       : 'onKeyUp',
            input       : 'onInput',
            focus       : 'onFocus',
            blur        : 'onBlur',
            paste       : 'onPaste',
            mousedown   : 'onMouseDown',
            clearicontap: 'onClearIconTap'
        });

        // set the originalValue of the textfield, if one exists
        me.originalValue = me.getValue() || "";
        me.getComponent().originalValue = me.originalValue;

        me.syncEmptyCls();
    },

    syncEmptyCls: function() {
        var val = this._value,
            empty = val ? val.length : false;

        this.toggleCls(this.emptyCls, empty);
    },

    applyValue: function(value) {
        return Ext.isEmpty(value) ? '' : value;
    },

    /**
     * @private
     */
    updateValue: function(value, oldValue) {
        var me = this,
            component  = me.getComponent(),
            // allows value to be zero but not undefined or null (other falsey values)
            valueValid = value !== undefined && value !== null && value !== '';

        if (component) {
            component.setValue(value);
        }

        me.toggleClearIcon(valueValid && me.isDirty())

        me.syncEmptyCls();

        if (me.initialized) {
            me.fireEvent('change', me, value, oldValue);
        }
    },

    /**
     * @private
     */
    updatePlaceHolder: function(newPlaceHolder) {
        this.getComponent().setPlaceHolder(newPlaceHolder);
    },

    /**
     * @private
     */
    updateMaxLength: function(newMaxLength) {
        this.getComponent().setMaxLength(newMaxLength);
    },

    /**
     * @private
     */
    updateAutoComplete: function(newAutoComplete) {
        this.getComponent().setAutoComplete(newAutoComplete);
    },

    /**
     * @private
     */
    updateAutoCapitalize: function(newAutoCapitalize) {
        this.getComponent().setAutoCapitalize(newAutoCapitalize);
    },

    /**
     * @private
     */
    updateAutoCorrect: function(newAutoCorrect) {
        this.getComponent().setAutoCorrect(newAutoCorrect);
    },

    /**
     * @private
     */
    updateReadOnly: function(newReadOnly) {
        this.toggleClearIcon(!newReadOnly);
        this.getComponent().setReadOnly(newReadOnly);
    },

    /**
     * @private
     */
    updateInputType: function(newInputType) {
        var component = this.getComponent();
        if (component) {
            component.setType(newInputType);
        }
    },

    /**
     * @private
     */
    updateName: function(newName) {
        var component = this.getComponent();
        if (component) {
            component.setName(newName);
        }
    },

    /**
     * @private
     */
    updateTabIndex: function(newTabIndex) {
        var component = this.getComponent();
        if (component) {
            component.setTabIndex(newTabIndex);
        }
    },

    /**
     * Updates the {@link #inputCls} configuration on this fields {@link #component}
     * @private
     */
    updateInputCls: function(newInputCls, oldInputCls) {
        var component = this.getComponent();
        if (component) {
            component.replaceCls(oldInputCls, newInputCls);
        }
    },

    updateDisabled: function(disabled, oldDisabled) {
        this.callParent([disabled, oldDisabled]);

        var component = this.getComponent();
        if (component) {
            component.setDisabled(disabled);
        }

        this.toggleClearIcon(!disabled);
    },

    /**
     * @private
     */
    showClearIcon: function() {
        var me         = this,
            value      = me.getValue(),
            // allows value to be zero but not undefined or null (other falsey values)
            valueValid = value !== undefined && value !== null && value !== "";

        if (me.getClearIcon() && !me.getDisabled() && !me.getReadOnly() && valueValid) {
            me.element.addCls(me.clearableCls);
        }

        return me;
    },

    /**
     * @private
     */
    hideClearIcon: function() {
        if (this.getClearIcon()) {
            this.element.removeCls(this.clearableCls);
        }
    },

    onKeyUp: function(e) {
        this.fireAction('keyup', [this, e], 'doKeyUp');
    },

    /**
     * Called when a key has been pressed in the `<input>`
     * @private
     */
    doKeyUp: function(me, e) {
        // getValue to ensure that we are in sync with the dom
        var value      = me.getValue(),
            // allows value to be zero but not undefined or null (other falsey values)
            valueValid = value !== undefined && value !== null && value !== '';

        me.toggleClearIcon(valueValid);

        if (e.browserEvent.keyCode === 13) {
            me.fireAction('action', [me, e], 'doAction');
        }
    },

    doAction: function() {
        this.blur();
    },

    onClearIconTap: function(input, e) {
        this.fireAction('clearicontap', [this, input, e], 'doClearIconTap');
    },

    /**
     * @private
     */
    doClearIconTap: function(me, e) {
        me.setValue('');
    },

    onInput: function(component, value) {
        this.setValue(value);
    },

    onFocus: function(e) {
        var me = this;

        me.addCls(me.focusedCls);
        me.isFocused = true;
        me.fireEvent('focus', me, e);
    },

    onBlur: function(e) {
        var me = this;

        me.removeCls(me.focusedCls);
        me.isFocused = false;

        me.fireEvent('blur', me, e);

        Ext.defer(function() {
            me.isFocused = false;
        }, 50);
    },

    onPaste: function(e) {
        this.fireEvent('paste', this, e);
    },

    onMouseDown: function(e) {
        this.fireEvent('mousedown', this, e);
    },

    /**
     * Attempts to set the field as the active input focus.
     * @return {Ext.field.Text} This field
     */
    focus: function() {
        this.getComponent().focus();
        return this;
    },

    /**
     * Attempts to forcefully blur input focus for the field.
     * @return {Ext.field.Text} This field
     */
    blur: function() {
        this.getComponent().blur();
        return this;
    },

    /**
     * Attempts to forcefully select all the contents of the input field.
     * @return {Ext.field.Text} this
     */
    select: function() {
        this.getComponent().select();
        return this;
    },

    resetOriginalValue: function() {
        var me = this,
            comp;

        me.callParent();
        component = me.getComponent();
        if(component && component.hasOwnProperty("originalValue")) {
            me.getComponent().originalValue = me.originalValue;
        }
        me.reset();
    },

    reset: function() {
        var me = this;
        me.getComponent().reset();

        //we need to call this to sync the input with this field
        me.getValue();

        me.toggleClearIcon(me.isDirty());
    },

    isDirty: function() {
        var component = this.getComponent();
        if (component) {
            return component.isDirty();
        }
        return false;
    },

    privates: {
        toggleClearIcon: function(state) {
            if (state) {
                this.showClearIcon();
            } else {
                this.hideClearIcon();
            }
        }
    }
});

