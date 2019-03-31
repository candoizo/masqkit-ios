// transaction:0x10242f840 didReceivePackets:0x103928070 receivedSize:0x29b requestedSize:0x2710 queue:0x1b53f1cc0 completion:0x16e142c68


//MRDNowPlayingServer
//MRDNowPlayingPlayerClient _onQueue_playbackQueueContentItemsArtworkDidChange:0x100b0d150]

%hook MRDTransactionServer
-(void)transaction:(id)arg1 didReceivePackets:(id)arg2 receivedSize:(id)arg3 requestedSize:(id)arg4 queue:(id)arg5 completion:(id)arg6 {
  %orig;

}
%end
