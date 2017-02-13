/**
 * @class BadgeMapping
 * @extends CQ.form.CompositeField
 * This is a custom widget based on {@link CQ.form.CompositeField}.
 * @constructor
 * Creates a new BadgeMapping.
 * @param {Object} config The config object
 */
BadgeMapping = CQ.Ext.extend(CQ.form.CompositeField, {

   /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    hiddenField: null,

    /**
     * @private
     * @type CQ.form.PathField
     */
    segmentField: null,

   /**
     * @private
     * @type CQ.form.TextField
     */
    badgeField: null,

    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": false,
            "layout": "table",
            "columns":2
        };
        config = CQ.Util.applyDefaults(config, defaults);
        BadgeMapping.superclass.constructor.call(this, config);
    },

    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        BadgeMapping.superclass.initComponent.call(this);

        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name
        });
        this.add(this.hiddenField);

        this.segmentField = new CQ.form.PathField({
            rootPath: "/etc/segmentation",
            predicate: "nosystem",
            showTitlesInTree: false,
              listeners: {
                change: {
                    scope:this,
                    fn:this.updateHidden
                },
                dialogclose: {
                    scope: this,
                    fn: this.updateHidden
                }
            },
            optionsProvider: this.optionsProvider

        });
        this.add(this.segmentField);

        this.badgeField= new CQ.Ext.form.TextField({
            maxLength: 10,
            maxLengthText: "A maximum of 10 characters is allowed for the Link Text.",
            allowBlank: false,
            listeners: {
                change: {
                    scope:this,
                    fn:this.updateHidden
                },
                dialogclose: {
                    scope: this,
                    fn: this.updateHidden
                }
            },
            optionsProvider: this.optionsProvider
        });
        this.add(this.badgeField);

    },

    // overriding CQ.form.CompositeField#processPath
    processPath: function(path) {
        this.segmentField.processPath(path);
    },

    // overriding CQ.form.CompositeField#processRecord
    processRecord: function(record, path) {
        this.segmentField.processRecord(record, path);
    },

    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        var parts = value.split("#");
        this.segmentField.setValue(parts[0]);
        this.badgeField.setValue(parts[1]);
        this.hiddenField.setValue(value);
    },

    // overriding CQ.form.CompositeField#getValue
    getValue: function() {
        return this.getRawValue();
    },

    // overriding CQ.form.CompositeField#getRawValue
    getRawValue: function() {
        if (!this.segmentField) {
            return null;
        }
         return this.segmentField.getValue() + "#" +
               this.badgeField.getValue();

    },

    // private
    updateHidden: function() {
        this.hiddenField.setValue(this.getValue());
    }

});

// register xtype
CQ.Ext.reg('badgemapping', BadgeMapping);