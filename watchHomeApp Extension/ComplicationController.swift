//
//  ComplicationController.swift
//  watchHomeApp Extension
//
//  Created by Matthias Fischer on 13.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import Foundation
import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication,
                                          withHandler handler:@escaping (CLKComplicationTimeTravelDirections) -> Void) {
        print("getSupportedTimeTravelDirections")
        handler([])
    }
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        print("getLocalizableSampleTemplate")
        handler(createTemplate(forComplication: complication))
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        print("getCurrentTimelineEntry")
        handler(createTimelineEntry(forComplication: complication, date: Date()))
    }
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        print("getPlaceholderTemplateForComplication")
        handler(createTemplate(forComplication: complication))
    }
    
    private func createTimelineEntry(forComplication complication: CLKComplication, date: Date) -> CLKComplicationTimelineEntry {
        let template = createTemplate(forComplication: complication)
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
    
    private func createTemplate(forComplication complication: CLKComplication) -> CLKComplicationTemplate {
        switch complication.family {
        case .modularSmall:
            return createModularSmallTemplate()
        case .modularLarge:
            return createModularLargeTemplate()
        case .utilitarianSmall, .utilitarianSmallFlat:
            return createUtilitarianSmallFlatTemplate()
        case .utilitarianLarge:
            return createUtilitarianLargeTemplate()
        case .circularSmall:
            return createCircularSmallTemplate()
        case .extraLarge:
            return createExtraLargeTemplate()
        case .graphicCorner:
            return createGraphicCornerTemplate()
        case .graphicCircular:
            return createGraphicCircleTemplate()
        case .graphicRectangular:
            return createGraphicRectangularTemplate()
        case .graphicBezel:
            return createGraphicBezelTemplate()
        case .graphicExtraLarge:
            return createGraphicExtraLargeTemplate()
        @unknown default:
            fatalError("*** Unknown Complication Family ***")
        }
    }
    
    private func imageProvider() -> CLKImageProvider {
        return CLKImageProvider(onePieceImage: UIImage(systemName: "house.fill")!)
    }
    
    private func imageProviderFullColor() -> CLKFullColorImageProvider {
        return CLKFullColorImageProvider(fullColorImage: UIImage(systemName: "house.fill")!)
    }
    
    private func imageProviderCircular() -> CLKComplicationTemplateGraphicCircularImage {
        return CLKComplicationTemplateGraphicCircularImage(imageProvider: imageProviderFullColor())
    }
    
    private func textProvider() -> CLKTextProvider {
        return CLKTextProvider(format: "Zuhause")
    }
    
    private func textProviderLineTwo() -> CLKTextProvider {
        return CLKTextProvider(format: "")
    }
    
    private func createModularSmallTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateModularSmallSimpleImage(imageProvider: imageProvider())
    }
    
    private func createModularLargeTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: textProvider(), body1TextProvider: textProvider())
    }
    
    private func createUtilitarianSmallFlatTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider())
    }
    
    private func createUtilitarianLargeTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider())
    }
    
    private func createCircularSmallTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: imageProvider())
    }
    
    private func createExtraLargeTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: imageProvider())
    }
    
    private func createGraphicCornerTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateGraphicCornerTextImage(textProvider: textProvider(), imageProvider: imageProviderFullColor())
    }
    
    private func createGraphicCircleTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateGraphicCircularImage(imageProvider: imageProviderFullColor())
    }
    
    private func createGraphicRectangularTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateGraphicRectangularFullImage(imageProvider: imageProviderFullColor())
    }
    
    private func createGraphicBezelTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: imageProviderCircular(), textProvider: textProvider())
    }
    
    private func createGraphicExtraLargeTemplate() -> CLKComplicationTemplate {
        return CLKComplicationTemplateGraphicExtraLargeCircularImage(imageProvider: imageProviderFullColor())
    }
    
}
