/*
 * TNLibvirtDomainClock.j
 *
 * Copyright (C) 2010 Antoine Mercadal <antoine.mercadal@inframonde.eu>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

@import <Foundation/Foundation.j>
@import <StropheCappuccino/TNXMLNode.j>

@import "TNLibvirtBase.j";
@import "TNLibvirtDomainClockTimer.j"

TNLibvirtDomainClockClockUTC        = @"utc";
TNLibvirtDomainClockClockLocalTime  = @"localtime";
TNLibvirtDomainClockClockTimezone   = @"timezone";
TNLibvirtDomainClockClockVariable   = @"variable";

TNLibvirtDomainClockClocks          = [ TNLibvirtDomainClockClockUTC,
                                        TNLibvirtDomainClockClockLocalTime];

/*! @ingroup virtualmachinedefinition
    Model for clock
*/
@implementation TNLibvirtDomainClock : TNLibvirtBase
{
    CPString    _offset     @accessors(property=offset);
    CPArray     _timers     @accessors(property=timers);
}


#pragma mark -
#pragma mark Initialization

/*! initialize the object
*/
- (TNLibvirtDomainClock)init
{
    if (self = [super init])
    {
        _timers = [CPArray array];
    }

    return self;
}

/*! initialize the object with a given XML node
    @param aNode the node to use
*/
- (id)initWithXMLNode:(TNXMLNode)aNode
{
    if (self = [super initWithXMLNode:aNode])
    {
        if ([aNode name] != @"clock")
            [CPException raise:@"XML not valid" reason:@"The TNXMLNode provided is not a valid clock"];

        _offset = [aNode valueForAttribute:@"offset"];
        _timers = [CPArray array];

        var timerNodes = [aNode ownChildrenWithName:@"timer"];
        for (var i = 0; i < [timerNodes count]; i++)
            [_timers addObject:[[TNLibvirtDomainClockTimer alloc] initWithXMLNode:[timerNodes objectAtIndex:i]]];
    }

    return self;
}


#pragma mark -
#pragma mark Generation

/*! return a TNXMLNode representing the object
    @return TNXMLNode
*/
- (TNXMLNode)XMLNode
{
    if (!_offset)
        [CPException raise:@"Missing offset" reason:@"clock offset is required"];

    var node = [TNXMLNode nodeWithName:@"clock" andAttributes:{@"offset": _offset}];

    for (var i = 0; i < [_timers count]; i++)
    {
        [node addNode:[[_timers objectAtIndex:i] XMLNode]];
        [node up];
    }

    return node;
}

@end
