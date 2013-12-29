#!/usr/bin/env python
# -*- coding: UTF-8 -*-
#The program will filiter the domain,which forward ip less than 4,then record it in the goodresult
#If the asn of ip are different ,then record it in the badresult
#Source file : list   Result file : result 

import os
import popen2

#NumberOfIP() check the number of ip which is forwarded by the domain
def NumberOfIP(domain):
	DataOut,DataIn = popen2.popen2("host -t A "+domain)
	SeparateIP = (DataOut.read()).split("\n")
	number = len(SeparateIP)

	return number

#NumberOfIP() check the number of asn which is forwarded by the ip forwarded by the domain
def NumberOfAsn(domain):
	ASN = []
	DataOut,DataIn = popen2.popen2("host -t A "+domain)
	SeparateIP = (DataOut.read()).split("\n")
	number = len(SeparateIP)
	for i in range(number-1):
		temp = SeparateIP[i].split()
		IP = temp[3]
		if IP not in "alias" :
			ASNOut,IPIN = popen2.popen2("whois -h whois.cymru.com "+IP)		
			SeparateASN = (ASNOut.read()).split("\n")
			temp = SeparateASN[1].split()
			if temp[0] not in ASN :
				ASN.append(temp[0])
	return len(ASN)	

if __name__=='__main__':
	fileopengood = open('goodresult','w')
	fileopenbad = open('badresult','w')
	for domain in open('list'):  
		if NumberOfIP(domain) > 4 :
			if NumberOfAsn(domain) > 1:
				fileopenbad.write(domain)
			else :
				fileopengood.write(domain)
				
	fileopengood.close()
	fileopenbad.close()
