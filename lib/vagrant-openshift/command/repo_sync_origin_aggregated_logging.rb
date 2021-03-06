#--
# Copyright 2013 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#++
require_relative "../action"

module Vagrant
  module Openshift
    module Commands
      class RepoSyncOriginAggregatedLogging < Vagrant.plugin(2, :command)
        include CommandHelper

        def self.synopsis
          "syncs your local repos to the current instance"
        end

        def execute
          options = {}
          options[:images] = true
          options[:build] = true
          options[:clean] = false
          options[:source] = false
          options[:repo] = 'origin-aggregated-logging'

          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant sync-origin-aggregated-logging [vm-name]"
            o.separator ""

            o.on("-s", "--source", "Sync the source (not required if using synced folders)") do |f|
              options[:source] = f
            end

            o.on("-c", "--clean", "Delete existing repo before syncing source") do |f|
              options[:clean] = f
            end

            o.on("--dont-install", "Don't build and install updated source") do |f|
              options[:build] = false
            end

            o.on("--no-images", "Don't build updated component Docker images") do |f|
              options[:images] = false
            end

          end

          # Parse the options
          argv = parse_options(opts)
          return if !argv

          with_target_vms(argv, :reverse => true) do |machine|
            actions = Vagrant::Openshift::Action.repo_sync_origin_aggregated_logging(options)
            @env.action_runner.run actions, {:machine => machine}
            0
          end
        end
      end
    end
  end
end
