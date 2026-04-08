clear;
clc;

date = datetime('now', 'Format', 'dd-MM-yy');
endtime = datetime('now', 'Format', 'HH:mm:ss.SSS');

vicon = ViconNexus();

numframe = double(vicon.GetFrameCount);
framerate = vicon.GetFrameRate;
triallength = numframe/framerate;

starttime = endtime - seconds(triallength);

subject = char(vicon.GetSubjectNames);
[filepath, trial] = vicon.GetTrialName;

file = append(filepath,trial);
save(file)


% ClearAllEvents                  GetDeviceOutputIDFromName       GetTrialName                    
% CloseTrial                      GetEvents                       GetTrialRange                   
% Connect                         GetFrameCount                   GetTrialRegionOfInterest        
% CreateAnEvent                   GetFrameRate                    GetUnlabeled                    
% CreateAnalysisParam             GetJointDetails                 GetUnlabeledCount               
% CreateModelOutput               GetJointNames                   HasTrajectory                   
% CreateModeledMarker             GetMarkerNames                  OpenTrial                       
% CreateSubjectParam              GetModelOutput                  RunPipeline                     
% GetAnalysisParam                GetModelOutputAtFrame           SaveTrial                       
% GetAnalysisParamDetails         GetModelOutputDetails           SetAnalysisParam                
% GetAnalysisParamNames           GetModelOutputNames             SetDeviceChannel                
% GetDeviceChannel                GetRootSegment                  SetDeviceChannelAtFrame         
% GetDeviceChannelAtFrame         GetSegmentDetails               SetModelOutput                  
% GetDeviceChannelForFrame        GetSegmentNames                 SetModelOutputAtFrame           
% GetDeviceChannelGlobal          GetServerInfo                   SetSubjectActive                
% GetDeviceChannelGlobalAtFrame   GetSplineResults                SetSubjectParam                 
% GetDeviceChannelGlobalForFrame  GetSubjectInfo                  SetTrajectory                   
% GetDeviceChannelIDFromName      GetSubjectNames                 SetTrajectoryAtFrame            
% GetDeviceDetails                GetSubjectParam                 SetTrialRegionOfInterest        
% GetDeviceIDFromName             GetSubjectParamDetails          SubmitSplineTrajectory          
% GetDeviceIDs                    GetSubjectParamNames            ViconNexus                      
% GetDeviceNames                  GetTrajectory                   
% GetDeviceOutputDetails          GetTrajectoryAtFrame            
