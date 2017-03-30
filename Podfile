source 'https://github.com/deltaDNA/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

target 'DeltaDNA' do
  pod 'DeltaDNAAds', '~> 1.3.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
	target.build_configurations.each do |config|
	    # Enable extra logging
	    if target.name == 'DeltaDNA' || target.name == 'DeltaDNAAds'           
            	config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
            	config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'DDNA_DEBUG=1'
            end
            # Disable bitcode
	    config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end

