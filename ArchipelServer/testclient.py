#!/usr/bin/python
import xmpp
import sys
from archipelBasicXMPPClient import *

class XMPPVirtualMachineController(ArchipelBasicXMPPClient):
                
    def send_iq(self, iq):
        print "LA";
        if sys.argv[2] == "trinity:vm:definition":
            f = open(sys.argv[4])
            data = f.read()
            f.close()
            iq.setQueryPayload(data)
        
        if  (sys.argv[2] == "trinity:hypervisor:control" and (sys.argv[3] == "alloc" or sys.argv[3] == "free")):
            iq.setQueryPayload([sys.argv[4]])
        
        print "sending iq : " + str(iq)
        self.xmppclient.send(iq)


    def register_handler(self):
        self.xmppclient.RegisterHandler('iq', self.__process_iq)
    
    def __process_iq(self, conn, iq):
        print str(iq)
        

iq = xmpp.Iq(typ=sys.argv[2], to=sys.argv[1])
iq.addChild(name="query", attrs={"type": sys.argv[3]})
iq.getTag("query").addChild(name="target", payload="vnet1");
# iq.getTag("query").addChild(name="target", payload="vnet0");

vm = XMPPVirtualMachineController("controller@pulsar.local", "password")
vm.register_actions_to_perform_on_auth("send_iq", iq)
vm.connect()
