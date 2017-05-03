//
//  QZWorkSheet.m
//  QZXLSReader
//
//  Created by Fernando Olivares on 10/27/13.
//  Copyright 2013 Fernando Olivares.
//

#import "xls.h"
#import "QZWorkSheet.h"
#import "QZWorkbook.h"
#import "QZCell.h"

@interface QZWorkSheet (){
    NSUInteger _sheetIndex;
    xlsWorkSheet *_workSheet;
}

@end

@implementation QZWorkSheet

@synthesize isOpen = _isOpen;
@synthesize name = _name;
@synthesize rows = _rows;
@synthesize columns = _columns;

- (id)initFromXLSWorkSheet:(xlsWorkSheet *)workSheet
                 withIndex:(NSUInteger)sheetIndex;
{
    if(self != [super init] || !workSheet)
        return nil;
    
    _workSheet = workSheet;
    _sheetIndex = sheetIndex;
    
    //Now, parse the info.
    st_sheet *newSheet = &workSheet->workbook->sheets;
    self.name = [NSString stringWithCString:(char *)newSheet->sheet[sheetIndex].name
                                   encoding:NSUTF8StringEncoding];
    _isOpen = NO;
    
    return self;
}

- (void)open;
{
    //Attempt to parse it.
    xls_parseWorkSheet(_workSheet);
    
    //Let's assume it's parsed.
    _isOpen = YES;

    //Get the rows and columns. Columns are easier because they depend on rows.
    NSMutableArray *rows = [NSMutableArray new];
    NSMutableArray *columns = nil;
    for(NSInteger rowCounter = 0; rowCounter < _workSheet->rows.lastrow + 1; rowCounter++){
        
        //Get our raw row and parse all of its cells.
        xlsRow *row = &_workSheet->rows.row[rowCounter];
        NSMutableArray *cells = [NSMutableArray new];
        for(NSInteger cellCounter = 0; cellCounter < row->cells.count; cellCounter++){
            xlsCell *cell = &row->cells.cell[cellCounter];
            QZCell *newCell = [[QZCell alloc] initWithContent:cell];
            
            if(newCell.location.row == row->index)
                [cells addObject:newCell];
        }
        
        if(cells.count > 0){
            //This row has cells. Save it.
            [rows addObject:cells];
            
            //Do we have our column arrays ready?
            if(!columns){
                //We don't have column arrays ready. Start creating each column with our first cell.
                columns = [NSMutableArray new];
                for(QZCell *cell in cells){
                    NSMutableArray *newColumn = [NSMutableArray arrayWithObject:cell];
                    [columns addObject:newColumn];
                }
            }else{
                //We do have columns, just keep adding the cells.
                NSEnumerator *columnEnumerator = [columns objectEnumerator];
                for(QZCell *cell in cells){
                    NSMutableArray *nextColumn = [columnEnumerator nextObject];
                    [nextColumn addObject:cell];
                }
            }
        }
    }
    
    self.rows = [NSArray arrayWithArray:rows];
    self.columns = [NSArray arrayWithArray:columns];
}

- (void)close;
{
    if(!self.isOpen || !_workSheet)
        return;
    
    xls_close_WS(_workSheet);
}

- (QZCell *)cellAtPoint:(QZLocation)location;
{
    if(!self.isOpen)
        return nil;
    
    xlsRow *rowP = &_workSheet->rows.row[location.row];
    xlsCell	*cell = &rowP->cells.cell[location.column];
	
	return [[QZCell alloc] initWithContent:cell];
}

- (NSArray *)arrayRepresentationOfSimpleWorkSheet;
{
    if(!self.isOpen || self.rows.count <= 0 || self.columns.count <= 0)
        return nil;
    
    //Get the keys from the firstRow.
    NSArray *firstRow = self.rows.firstObject;
    NSMutableArray *arrayRepresentation = [NSMutableArray new];
    
    //Each row is a new object.
    for(NSArray *row in self.rows){
        if([row isEqual:firstRow])
            continue;
        
        //Start parsing each object after the first row.
        NSMutableDictionary *newObject = [NSMutableDictionary new];
        NSEnumerator *firstRowEnumerator = [firstRow objectEnumerator];
        for(QZCell *cell in row){
            QZCell *nextObject = [firstRowEnumerator nextObject];
            if(nextObject)
                [newObject setObject:cell.content forKey:nextObject.content];
        }
        
        if(newObject.allKeys.count > 0)
            [arrayRepresentation addObject:newObject];
    }
    
    return arrayRepresentation;
}

@end