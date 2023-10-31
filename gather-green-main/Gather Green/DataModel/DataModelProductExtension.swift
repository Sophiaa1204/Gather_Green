//
//  DataModelProduct.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/22/23.
//

import Foundation

class ProductSize{
    var length: Float
    var width: Float
    var height: Float
    var volume: Float{
        self.length * self.width * self.height
    }
    
    init(length: Float, width: Float, height: Float){
        self.length = length
        self.width = width
        self.height = height
    }
}

class ProductSupplement{
    var name: String
    
    var description: String{
        ProductSupplement.nameToDescription(name)
    }
    var size: ProductSize{
        ProductSupplement.nameToSize(name)
    }
    var source: String{
        ProductSupplement.nameToSource(name)
    }
    var weight: Float{
        ProductSupplement.nameToWeight(name)
    }
    
    static func nameToDescription(_ name: String) -> String{
        let nameDescriptionDict: [String: String] =
        [
        "Wine Glass": "4-pack of stemless wine glass ideal for everyday use or entertaining",
         "Draft Paper": "Legal note pad for everyday writing; ideal for home, office, school, or business",
         "plastic bag": "Ideal For: Grocery, Retail, Restaurants and Shopping",
         "Cardboard": "Use the boards for extra protection against bending when putting important documents and letters in the mail; also great for photo backing, picture frame or welcome sign",
         "Used Paper": "8.5 x 11 white copier and printer paper for home or office use",
         "card board": "Use the boards for extra protection against bending when putting important documents and letters in the mail; also great for photo backing, picture frame or welcome sign",
         "Coloured Paper": "Perfect for diy arts and crafts,paper cutting,drawing paper, color printing or copying, colourful origami paper creates the most beautiful artwork.",
         "plastic toy car": "Built in the USA from 100% recycled plastic milk containers that saves energy and reduces greenhouse gas emissions",
         "Plastic Chair": "The leg ,solid cross design ,the bearing stress of solid chair,all only for you to sit more safer and more comfortable",
         "Wooden Chair": "Versatile dining chair for weddings, ballroms, catering, hotels, graduations and other events",
         "Bookcase": "One shelf is fixed for stability while the other can be adjusted to accommodate items of various sizes",
         "Laundry Basket": "Collapsible Design: Laundry basket can be easily folded up to save space when not in use, ideal for college dorms, campers, apartments, hotel use, baby nurseries and utility room.",
         "Desk Lamp": "Painted metal shade and plastic base with flexible hose neck",
         "Rug": "Ultra-soft area rug — Feature 1.57” shag carpet surface, the Ophanie soft area rug is incredibly soft with a high-density sponge interlayer. No more shedding faux fur and an upgraded non-slip bottom — The high-density small and durable anti-slip dots at the bottom enhances friction to prevent it from sliding. No need for an additional pad underneath. Please note: water under the rug can cause it to slip. Keep the bottom of the rug dry.",
        ]
        if let description = nameDescriptionDict[name]{
            return description
        }else{
            return ""
        }
    }
    
    static func nameToSize(_ name: String) -> ProductSize{
        let nameSizeDict: [String: ProductSize] =
        [
         "Wine Glass": ProductSize(length: 4, width: 4, height: 6),
         "Draft Paper": ProductSize(length: 12, width: 8.5, height: 1),
         "plastic bag": ProductSize(length: 11.5, width: 6.5, height: 21),
         "Cardboard": ProductSize(length: 10, width: 8, height: 0.08),
         "Used Paper": ProductSize(length: 11.5, width: 8.5, height: 0.5),
         "card board": ProductSize(length: 10, width: 8, height: 0.08),
         "Coloured Paper": ProductSize(length: 11.5, width: 8.5, height: 0.05),
         "plastic toy car": ProductSize(length: 6.26, width: 3.5, height: 2.24),
         "Plastic Chair": ProductSize(length: 21.5, width: 18.8, height: 33),
         "Wooden Chair": ProductSize(length: 18, width: 5.75, height: 36.25),
         "Bookcase": ProductSize(length: 36, width: 15, height: 29),
         "Laundry Basket": ProductSize(length: 15, width: 15, height: 20),
         "Desk Lamp": ProductSize(length: 4.9, width: 6.1, height: 14.85),
         "Rug": ProductSize(length:36, width: 24, height: 1.5),
        ]
        if let size = nameSizeDict[name]{
            return size
        }else{
            return ProductSize(length: 10, width: 8, height: 0.1)
        }
    }
    
    static func nameToSource(_ name: String) -> String{
        let nameSourceDict: [String: String] =
        [
        "Wine Glass": "Duke University",
         "Draft Paper": "Duke University",
         "plastic bag": "Duke University",
         "Cardboard": "Duke University",
         "Used Paper": "Duke University",
         "card board": "Duke University",
         "Coloured Paper": "Duke University",
         "plastic toy car": "Duke University",
         "Plastic Chair": "Duke University",
         "Wooden Chair": "Duke University",
         "Bookcase": "Duke University",
         "Laundry Basket": "Duke University",
         "Desk Lamp": "Duke University",
         "Rug": "Duke University",
        ]
        if let source = nameSourceDict[name]{
            return source
        }else{
            return ""
        }
    }
    
    static func nameToWeight(_ name: String) -> Float{
        let nameWeightDict: [String: Float] =
        [
            "Wine Glass": 2.4,
         "Draft Paper": 1.8,
            "plastic bag": 4.0,
            "Cardboard": 1.5,
         "Used Paper": 20,
         "card board": 1.8,
            "Coloured Paper": 3.0,
            "plastic toy car": 0.6,
            "Plastic Chair": 7.5,
         "Wooden Chair": 11,
         "Bookcase": 46,
         "Laundry Basket": 1.2,
         "Desk Lamp": 1.65,
         "Rug": 1.6,
        ]
        if let weight = nameWeightDict[name]{
            return weight
        }else{
            return 1.8
        }
    }
    
    init(){
        self.name = "name"
    }
    
    init(name: String){
        self.name = name
    }
}

extension Product{
    var autoDescription: String{
        return ProductSupplement.nameToDescription(self.name)
    }
    
    var autoSize: ProductSize{
        return ProductSupplement.nameToSize(self.name)
    }
    
    var autoSource: String{
        return ProductSupplement.nameToSource(self.name)
    }
    
    var autoWeight: Float{
        return ProductSupplement.nameToWeight(self.name)
    }
}
