package sim;

import java.io.Serializable;

public class property implements Serializable {
    /*
        Property class

        A property should be able to hold a certain set of data that can 
        be provided at a later date/manipulated by other classes. This
        should be generalisable to the degree where new properties can be
        added without compromising previous interactions.

        String name;                 - The name of the property, mostly for
                                     human reference
        String purpose;              - The purpose of the property (i.e. the
                                     use cases).
        Object value;                - The aspect of the property that stores
                                     the meaningful information relevant to
                                     this property.
    */

    private static final long serialVersionUID = 20672609912364060L;

    private String name;
    private String purpose;
    private Object value;

    public property(String iname, Object ivalue, String... ipurpose)
    {
        if (ipurpose.length<=0){purpose="--No purpose provided--";} else{purpose=ipurpose[0];};
        name = iname;
        value = ivalue;
    }



    // -------------------------------- pubilc Get/Set methods ------------------------------------//
    public String getName() {return name;}
    public void setName(String newName) {name = newName;}



    public String getPurpose() {return purpose;}
    public void setPurpose(String newPurpose) {purpose = newPurpose;}



    public Object getValue(){return value;}
    public void setValue(Object newValue){value = newValue;}


    public property(property prop){
        this.name    = prop.getName();
        this.purpose = prop.getPurpose();
        this.value   = prop.getValue();
    }
    public static property newInstance(property prop){
        return new property(prop);
    }

}
