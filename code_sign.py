from pbxproj import XcodeProject
import sys

# open the project
project = XcodeProject.load('ios/Runner.xcodeproj/project.pbxproj')

team_id = sys.argv[1] # first argument for team_id
issuer_id = sys.argv[2] # second argument for issuer_id
profile_name = sys.argv[3]

# Add code sign
project.add_code_sign('iPhone Distribution',
						  team_id,
						  issuer_id,
						  profile_name)
project.remove_flags('CODE_SIGN_STYLE', 'Automatic')
project.add_flags('CODE_SIGN_STYLE', 'manual')
# save the project, otherwise your changes won't be picked up by Xcode
project.save()


# Signign Pods
project = XcodeProject.load('ios/Pods/Pods.xcodeproj/project.pbxproj')

# Add code sign
project.add_code_sign('iPhone Distribution',
                          team_id,
                          issuer_id,
                          "")

project.add_flags("DEVELOPMENT_TEAM[sdk=iphoneos*]", team_id)
# save the project, otherwise your changes won't be picked up by Xcode
project.save()