require_relative '../../test_helper'
require 'api/telemetry_api'

describe "Telemetry API interface" do

  before do
    @api = RedHatSupportLib::TelemetryApi::Client.new('https://locahost:3000',
                                                      nil,
                                                      self,
                                                      nil
    )
    def @api.get_machines;
      [1, 2, 3, 4];
    end

    def @api.get_branch_id;
      'my_branch_id';
    end
  end

  it "Correctly calculates hash id " do
    @api.get_hash(@api.get_machines).must_equal('my_branch_id__7110eda4d09e062aa5e4a390b0a572ac0d2c0220')
  end

  describe "Subset path creation function" do
    before do
      def @api.get_hash(machines)
        'my_branch_id__my_hash_id'
      end
    end

    it "Correctly creates a subset path from an unversioned resource path" do
      @api.create_subset_route('systems/status').must_equal('subsets/my_branch_id__my_hash_id/systems/status')
      @api.create_subset_route('systems').must_equal('subsets/my_branch_id__my_hash_id/systems')
      @api.create_subset_route('reports').must_equal('subsets/my_branch_id__my_hash_id/reports')
    end

    it "Correctly creates a subset path from a versioned resource path" do
      @api.create_subset_route('latest/systems').must_equal('latest/subsets/my_branch_id__my_hash_id/systems')
      @api.create_subset_route('v1/systems/status').must_equal('v1/subsets/my_branch_id__my_hash_id/systems/status')
      @api.create_subset_route('v3/reports').must_equal('v3/subsets/my_branch_id__my_hash_id/reports')
    end

    it "Correctly creates a subset path for topics" do
      @api.create_subset_route('latest/topics').must_equal('latest/subsets/my_branch_id__my_hash_id/topics')
      @api.create_subset_route('latest/topics/id').must_equal('latest/subsets/my_branch_id__my_hash_id/topics/id')
      @api.create_subset_route('v3/topics').must_equal('v3/subsets/my_branch_id__my_hash_id/topics')
      @api.create_subset_route('v3/topics/id').must_equal('v3/subsets/my_branch_id__my_hash_id/topics/id')
    end

    it "Correctly creates a subset path for exports" do
      @api.create_subset_route('latest/exports/reports').must_equal('latest/subsets/my_branch_id__my_hash_id/exports/reports')
      @api.create_subset_route('v3/exports/reports').must_equal('v3/subsets/my_branch_id__my_hash_id/exports/reports')
    end

    it "Correctly creates a subset path for maintainance stats" do
      @api.create_subset_route('latest/stats/reports').must_equal('latest/subsets/my_branch_id__my_hash_id/stats/reports')
      @api.create_subset_route('v3/stats/reports').must_equal('v3/subsets/my_branch_id__my_hash_id/stats/reports')
      @api.create_subset_route('latest/stats/systems').must_equal('latest/subsets/my_branch_id__my_hash_id/stats/systems')
      @api.create_subset_route('v3/stats/systems').must_equal('v3/subsets/my_branch_id__my_hash_id/stats/systems')
      @api.create_subset_route('latest/stats/rules').must_equal('latest/subsets/my_branch_id__my_hash_id/stats/rules')
      @api.create_subset_route('v3/stats/rules').must_equal('v3/subsets/my_branch_id__my_hash_id/stats/rules')
    end

    it "Correctly creates a subset path for maintenance" do
      @api.create_subset_route('latest/maintenance').must_equal('latest/subsets/my_branch_id__my_hash_id/maintenance')
      @api.create_subset_route('v3/maintenance').must_equal('v3/subsets/my_branch_id__my_hash_id/maintenance')
      assert_nil(@api.create_subset_route('latest/maintenance/xyz'))
      assert_nil(@api.create_subset_route('v3/maintenance/xyz'))
    end


    it "Returns nil when a path is not a subset resouce" do
      assert_nil(@api.create_subset_route('systems/echo'))
    end
  end
end